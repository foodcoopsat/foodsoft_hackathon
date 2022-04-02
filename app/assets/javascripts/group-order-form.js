class GroupOrderForm {
  constructor(form$, units) {
    this.form$ = form$;
    this.units = units;

    this.initializeIncreaseDecreaseButtons();
  }

  initializeIncreaseDecreaseButtons() {
    this.form$.find('tr.order-article').each((_, element) => this.initializeOrderArticleRow($(element)));
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

    quantityAndTolerance$.change(() => this.updateMissingUnits(row$, quantity$));
    quantityAndTolerance$.keyup(() => quantity$.trigger('change'));
  }

  increaseOrDecrease(field$, increase) {
    let granularity = parseFloat(field$.attr('step'));
    if (!increase) {
      granularity *= -1;
    }
    let value = parseFloat(field$.val());

    value = value + granularity;
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

    const missing$ = row$.find('.missing-units');

    const quantity = parseFloat(quantity$.val());
    const tolerance = parseFloat(tolerance$.val());
    const ratioGroupOrderUnitSupplierUnit = quantity$.data('ratio-group-order-unit-supplier-unit');

    // const quantityIncludingTolerance = quantity + tolerance;
    const unused = quantity % ratioGroupOrderUnitSupplierUnit;
    const missing = ratioGroupOrderUnitSupplierUnit - unused;
    const used = quantity - unused;

    let usedTolerance = 0;
    let unusedTolerance = tolerance;
    if (unusedTolerance >= missing) {
      usedTolerance = missing;
      unusedTolerance -= missing;
    }

    unused$.text(unused);
    used$.text(used);

    usedTolerance$.text(usedTolerance);
    unusedTolerance$.text(unusedTolerance);

    missing$.text(missing - usedTolerance);
  }
}
