class GroupOrderForm {
  constructor(form$, config) {
    this.form$ = form$;
    this.articleRows$ = this.form$.find('tr.order-article');
    this.totalPrice$ = this.form$.find('#total_price');
    this.newBalance$ = this.form$.find('#new_balance');
    this.totalBalance$ = this.form$.find('#total_balance');
    this.submitButton$ = this.form$.find('#submit_button');
    this.units = config.units;
    this.toleranceIsCostly = config.toleranceIsCostly;
    this.groupBalance = config.groupBalance;
    this.minimumBalance = config.minimumBalance;

    // TODO: Actually use this!:
    this.stockit = config.stockit;

    this.initializeIncreaseDecreaseButtons();
  }

  initializeIncreaseDecreaseButtons() {
    this.articleRows$.each((_, element) => this.initializeOrderArticleRow($(element)));
  }

  initializeOrderArticleRow(row$) {
    const quantity$ = row$.find('.goa-quantity');
    const tolerance$ = row$.find('.goa-tolerance');
    // eslint-disable-next-line no-undef
    const quantityAndTolerance$ = mergeJQueryObjects([quantity$, tolerance$]);
    // eslint-disable-next-line no-undef
    quantityAndTolerance$.each((_, element) => new UnitConversionField(
      $(element),
      this.units,
      this.form$.find('#unit_conversion_popover_content_template'),
      'group-order-unit'
    ));
    row$.find('.btn-ordering').mousedown((e) => e.preventDefault());
    row$.find('.btn-ordering.decrease').click((event) => this.increaseOrDecrease($(event.target).parents('.btn-group').find('input.numeric'), false));
    row$.find('.btn-ordering.increase').click((event) => this.increaseOrDecrease($(event.target).parents('.btn-group').find('input.numeric'), true));

    quantityAndTolerance$.change(() => {
      this.updateMissingUnits(row$, quantity$);
      this.updateBalance();
    });
    quantityAndTolerance$.keyup(() => quantity$.trigger('change'));
  }

  updateBalance() {
    const total = this.articleRows$
      .toArray()
      .reduce((acc, row) =>
        acc + parseFloat($(row).find('*[id^="price_"][id$="_display"]').data('price')),
        0
      );

    this.totalPrice$.text(I18n.l('currency', total));
    const balance = this.groupBalance - total;
    this.newBalance$.text(I18n.l('currency', balance));

    // TODO: Figure out why this hidden field is required (Should be
    // calculated in the controller IMO!):
    this.totalBalance$.val(I18n.l('currency', balance));

    // determine bgcolor and submit button state according to balance
    var bgcolor = '';
    if (balance < this.minimumBalance) {
        bgcolor = '#FF0000';
        this.submitButton$.attr('disabled', 'disabled')
    } else {
      this.submitButton$.removeAttr('disabled')
    }

    // update bgcolor
    this.articleRows$.find('*[id^="td_price_"]').css('background-color', bgcolor);
  }

  increaseOrDecrease(field$, increase) {
    let step = parseFloat(field$.attr('step'));
    if (isNaN(step)) {
      step = 1;
    }
    if (!increase) {
      step *= -1;
    }
    let value = parseFloat(field$.val());

    value += step;
    let remainder = value % step;
    if (remainder !== 0) {
      if (!increase) {
        remainder *= -1;
      }
      value += remainder - step;
    }
    const min = field$.attr('min');
    if (min !== undefined) {
      value = Math.max(parseFloat(min), value);
    }

    const max = field$.attr('max');
    if (max !== undefined) {
      value = Math.min(parseFloat(max), value);
    }

    field$.val(value);
    field$.trigger('change');
  }

  updateMissingUnits(row$) {
    const used$ = row$.find('.quantity .used');
    const unused$ = row$.find('.quantity .unused');

    const quantity$ = row$.find('.goa-quantity');
    const tolerance$ = row$.find('.goa-tolerance');
    const usedTolerance$ = row$.find('.tolerance .used');
    const unusedTolerance$ = row$.find('.tolerance .unused');
    const totalPacks$ = row$.find('.article-info *[id^="units_"]');
    const totalQuantity$ = row$.find('.article-info *[id^="q_total_"]');
    const totalTolerance$ = row$.find('.article-info *[id^="t_total_"]');
    const totalPrice$ = row$.find('*[id^="price_"][id$="_display"]');

    const missing$ = row$.find('.missing-units');

    const quantity = parseFloat(quantity$.val().trim().replace(',', '.'));
    const granularity = parseFloat(quantity$.attr('step'));
    const tolerance = tolerance$.length === 1 ? parseFloat(tolerance$.val().trim().replace(',', '.')) : 0;
    const packSize = quantity$.data('ratio-group-order-unit-supplier-unit');
    const othersQuantity = quantity$.data('others-quantity');
    const othersTolerance = quantity$.data('others-tolerance');
    const usedQuantity = quantity$.data('used-quantity');
    const minimumOrderQuantity = quantity$.data('minimum-order-quantity');
    const price = quantity$.data('price');

    const totalQuantity = quantity + othersQuantity;
    const totalTolerance = tolerance + othersTolerance;

    const totalPacks = this.calculatePacks(packSize, totalQuantity, totalTolerance)

    const totalPrice = price * (quantity + (this.toleranceIsCostly ? tolerance : 0));

    // update used/unused quantity
    const available = Math.max(0, totalPacks * packSize - othersQuantity);
    let used = Math.min(available, quantity);
    // ensure that at least the amout of items this group has already been allocated is used
    if (quantity >= usedQuantity && used < usedQuantity) {
      used = usedQuantity;
    }

    const unused = quantity - used;

    const availableForTolerance = Math.max(0, available - used - othersTolerance);
    const usedTolerance = Math.min(availableForTolerance, tolerance);
    const unusedTolerance = tolerance - usedTolerance;

    const missing = this.calcMissingItems(packSize, totalQuantity, totalTolerance)

    used$.text(isNaN(used) ? '?' : used);
    unused$.text(isNaN(unused) ? '?' : round(unused, 2));

    usedTolerance$.text(isNaN(usedTolerance) ? '?' : usedTolerance);
    unusedTolerance$.text(isNaN(unusedTolerance) ? '?' : unusedTolerance);

    totalPacks$.text(totalPacks);

    totalPacks$.css('color', this.packCompletedFromTolerance(packSize, totalQuantity, totalTolerance) ? 'grey' : 'auto');

    totalQuantity$.text(totalQuantity);
    totalTolerance$.text(totalTolerance);
    totalPrice$.text(I18n.l('currency', totalPrice));
    totalPrice$.data('price', totalPrice);

    missing$.text(round(missing, 2));
    if (packSize > 1) {
      this.setRowStyle(row$, missing, granularity);
    }
  }

  setRowStyle(row$, missing, granularity) {
    row$.removeClass('missing-many missing-few missing-none');
    if (missing === 0) {
      row$.addClass('missing-none');
    } else {
      row$.addClass(missing <= granularity ? 'missing-few' : 'missing-many');
    }
  }

  calculatePacks(packSize, quantity, tolerance) {
    const used = Math.floor(quantity / packSize)
    const remainder = quantity % packSize
    return used + ((remainder > 0) && (remainder + tolerance >= packSize) ? 1 : 0)
  }

  calcMissingItems(packSize, quantity, tolerance) {
    var remainder = quantity % packSize
    if (isNaN(remainder)) {
      return remainder;
    }
    return remainder > 0 && remainder + tolerance < packSize ? packSize - remainder - tolerance : 0
  }

  packCompletedFromTolerance(packSize, quantity, tolerance) {
    var remainder = quantity % packSize
    return (remainder > 0 && (remainder + tolerance >= packSize));
  }
}


function round(num, precision) {
  const factor = precision * Math.pow(10, precision);
  return Math.round((num + Number.EPSILON) * factor) / factor;
}
