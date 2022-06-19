class ArticleForm {
  constructor(articleUnitRatioTemplate$, articleForm$, units, priceMarkup, fieldNamePrefix = 'article') {
    try {
      this.units = units;
      this.priceMarkup = priceMarkup;
      this.unitFieldsPrefix = fieldNamePrefix;
      this.articleUnitRatioTemplate$ = articleUnitRatioTemplate$;
      this.articleForm$ = articleForm$;
      this.unitConversionPopoverTemplate$ = this.articleForm$.find('#unit_conversion_popover_content_template');
      this.unit$ = $(`#${this.unitFieldsPrefix}_unit`, this.articleForm$);
      this.supplierUnitSelect$ = $(`#${this.unitFieldsPrefix}_supplier_order_unit`, this.articleForm$);
      this.unitRatiosTable$ = $('#fc_base_price', this.articleForm$);
      this.minimumOrderQuantity$ = $(`#${this.unitFieldsPrefix}_minimum_order_quantity`, this.articleForm$);
      this.billingUnit$ = $(`#${this.unitFieldsPrefix}_billing_unit`, this.articleForm$);
      this.groupOrderUnit$ = $(`#${this.unitFieldsPrefix}_group_order_unit`, this.articleForm$);
      this.price$ = $(`#${this.unitFieldsPrefix}_price`, this.articleForm$);
      this.priceUnit$ = $(`#${this.unitFieldsPrefix}_price_unit`, this.articleForm$);
      this.tax$ = $(`#${this.unitFieldsPrefix}_tax`, this.articleForm$);
      this.deposit$ = $(`#${this.unitFieldsPrefix}_deposit`, this.articleForm$);
      this.fcPrice$ = $(`#${this.unitFieldsPrefix}_fc_price`, this.articleForm$);
      this.unitsToOrder$ = $('#order_article_units_to_order', this.articleForm$);
      this.unitsReceived$ = $('#order_article_units_received', this.articleForm$);
      this.select2Config = {
        dropdownParent: this.articleForm$.parents('#modalContainer')
      };

      this.loadAvailableUnits();
      this.initializeRegularFormFields();

      this.initializeRatioRows();
      this.bindAddRatioButton();

      this.setFieldVisibility();

      this.loadRatios();
      this.prepareRatioDataForSequentialRepresentation();
      this.convertPriceToPriceUnit();
      this.initializePriceDisplay();
      this.initializeOrderedAndReceivedUnits();
      this.convertOrderedAndReceivedUnits(this.supplierUnitSelect$.val(), this.billingUnit$.val());
      this.initializeFormSubmitListener();
    } catch (e) {
      console.log('Could not initialize article form', e);
    }
  }

  initializePriceDisplay() {
    mergeJQueryObjects([this.price$, this.priceUnit$]).on('change keyup', () => {
      const price = parseFloat(this.price$.val());
      const tax = parseFloat(this.tax$.val());
      const deposit = parseFloat(this.deposit$.val());
      const grossPrice = (price + deposit) * (tax / 100 + 1);
      const fcPrice = grossPrice  * (this.priceMarkup / 100 + 1);
      const priceUnitLabel = this.getUnitLabel(this.priceUnit$.val());
      let unitSuffix = priceUnitLabel.trim() === '' ? '' : ` x ${priceUnitLabel}`;
      this.fcPrice$.text(isNaN(fcPrice) ? '?' : `${I18n.l('currency', fcPrice)}${unitSuffix}`);
    });

    this.price$.trigger('change');
  }

  getUnitLabel(unitKey) {
    if (unitKey === '') {
      return this.unit$.val();
    }
    const unit = this.availableUnits.find((availableUnit) => availableUnit.key === unitKey);
    if (unit === undefined) {
      return '?';
    }
    return unit.label;
  }

  initializeFormSubmitListener() {
    this.articleForm$.submit(() => {
      this.undoSequentialRatioDataRepresentation();
      this.loadRatios();
      this.undoPriceConversion();
      this.undoOrderAndReceivedUnitsConversion();
    });
  }

  getUnitRatio(quantity, inputUnit, outputUnit) {
    const converter = new UnitsConverter(this.units, this.ratios, this.supplierUnitSelect$.val());
    return converter.getUnitRatio(quantity, inputUnit, outputUnit);
  }

  undoPriceConversion() {
    const relativePrice = this.price$.val();
    const ratio = this.getUnitRatio(1, this.priceUnit$.val(), this.groupOrderUnit$.val());
    const groupOrderUnitPrice = relativePrice / ratio;
    const hiddenPriceField$ = $(`<input type="hidden" name="${this.price$.attr('name')}" value="${groupOrderUnitPrice}" />`);
    this.articleForm$.append(hiddenPriceField$);
  }

  undoOrderAndReceivedUnitsConversion() {
    this.convertOrderedAndReceivedUnits(this.billingUnit$.val(), this.supplierUnitSelect$.val());
  }

  loadAvailableUnits() {
    this.availableUnits = Object.entries(this.units)
      .filter(([, unit]) => unit.visible)
      .map(([code, unit]) => ({ key: code, label: unit.name, baseUnit: unit.baseUnit }));

    $(`#${this.unitFieldsPrefix}_supplier_order_unit`, this.articleForm$).select2(this.select2Config);
  }

  initializeRegularFormFields() {
    this.unit$.change(() => {
      this.setMinimumOrderUnitDisplay();
      this.updateAvailableBillingAndGroupOrderUnits();
    });
    this.unit$.keyup(() => this.unit$.trigger('change'));


    this.supplierUnitSelect$.change(() => {
      this.onSupplierUnitChanged();
    });
    this.onSupplierUnitChanged();
  }

  onSupplierUnitChanged() {
    const valueChosen = this.supplierUnitSelect$.val() !== undefined && this.supplierUnitSelect$.val().trim() !== '';
    this.unit$.prop('disabled', valueChosen);
    this.unit$.toggle(!valueChosen);
    this.filterAvailableRatioUnits();
    this.setMinimumOrderUnitDisplay();
    this.updateAvailableBillingAndGroupOrderUnits();
    this.updateUnitMultiplierLabels();
  }

  setMinimumOrderUnitDisplay() {
    const chosenOptionLabel = this.supplierUnitSelect$.val() !== ''
      ? $(`option[value="${this.supplierUnitSelect$.val()}"]`, this.supplierUnitSelect$).text()
      : undefined;
    const unitVal = $(`#${this.unitFieldsPrefix}_unit`).val();
    this.minimumOrderQuantity$
      .parents('.input-append')
      .find('.add-on')
      .text(chosenOptionLabel !== undefined ? chosenOptionLabel : unitVal);
  }

  bindAddRatioButton() {
    $('*[data-add-ratio]', this.articleForm$).on('click', (e) => {
      e.preventDefault();
      e.stopPropagation();

      this.onAddClicked();
    });
  }

  onAddClicked() {
    const newRow$ = this.articleUnitRatioTemplate$.clone();
    $('tbody', this.unitRatiosTable$).append(newRow$);

    const index = $(`input[name^="${this.unitFieldsPrefix}[article_unit_ratios_attributes]"][name$="[sort]"]`, this.articleForm$).length
      + $(`input[name^="${this.unitFieldsPrefix}[article_unit_ratios_attributes]"][name$="[_destroy]"]`, this.articleForm$).length;

    const sortField$ = $('[name$="[sort]"]', newRow$);
    sortField$.val(index);

    const ratioAttributeFields$ = $(`[id^="${this.unitFieldsPrefix}_article_unit_ratios_attributes_0_"]`, newRow$);
    ratioAttributeFields$.each((_, field) => {
      $(field).attr('name', $(field).attr('name').replace('[0]', `[${index}]`));
      $(field).attr('id', $(field).attr('id').replace(`${this.unitFieldsPrefix}_article_unit_ratios_attributes_0_`, `${this.unitFieldsPrefix}_article_unit_ratios_attributes_${index}_`));
    });

    this.setFieldVisibility();

    this.initializeRatioRows();
  }

  initializeRatioRows() {
    $('tr', this.unitRatiosTable$).each((_, row) => {
      this.initializeRatioRow($(row));
    });

    this.updateUnitMultiplierLabels();
    this.filterAvailableRatioUnits();
  }

  initializeRatioRow(row$) {
    $('*[data-remove-ratio]', row$)
      .off('click.article_form_ratio_row')
      .on('click.article_form_ratio_row', (e) => {
        e.preventDefault();
        e.stopPropagation();
        this.removeRatioRow($(e.target).parents('tr'));
      });

    const select$ = $('select[name$="[unit]"]', row$);
    select$.change(() => {
      this.filterAvailableRatioUnits(row$)
      this.updateUnitMultiplierLabels();
    });
    select$.select2(this.select2Config);
  }

  updateUnitMultiplierLabels() {
    $('tr', this.unitRatiosTable$).each((_, row) => {
      const row$ = $(row);
      const aboveUnit = this.findAboveUnit(row$);
      $('.unit_multiplier', row$).text(aboveUnit);
    });
  }

  removeRatioRow(row$) {
    const index = row$.index() + 1;
    const id = $(`[name="${this.unitFieldsPrefix}[article_unit_ratios_attributes][${index}][id]"]`, this.articleForm$).val();
    row$.remove();

    $(this.unitRatiosTable$).after($(`<input type="hidden" name="${this.unitFieldsPrefix}[article_unit_ratios_attributes][${index}][_destroy]" value="true">`));
    $(this.unitRatiosTable$).after($(`<input type="hidden" name="${this.unitFieldsPrefix}[article_unit_ratios_attributes][${index}][id]" value="${id}">`));
    this.filterAvailableRatioUnits();
    this.updateUnitMultiplierLabels();
    this.setFieldVisibility();
  }

  filterAvailableRatioUnits() {
    const isUnitOrBaseUnitSelected = (unit, select$) => {
      const code = select$.val();
      const selectedUnit = this.units[code];
      return unit.key !== code && (!unit.baseUnit || !selectedUnit || !selectedUnit.baseUnit || unit.baseUnit !== selectedUnit.baseUnit);
    };

    let remainingAvailableUnits = this.availableUnits.filter(unit => isUnitOrBaseUnitSelected(unit, this.supplierUnitSelect$));

    $('tr select[name$="[unit]"]', this.unitRatiosTable$).each((_, unitSelect) => {
      $('option[value!=""]' + remainingAvailableUnits.map(unit => `[value!="${unit.key}"]`).join(''), unitSelect).remove();
      const missingUnits = remainingAvailableUnits.filter(unit => $(`option[value="${unit.key}"]`, unitSelect).length === 0);
      for (const missingUnit of missingUnits) {
        $(unitSelect).append($(`<option value="${missingUnit.key}">${missingUnit.label}</option>`));
      }
      remainingAvailableUnits = remainingAvailableUnits.filter(unit => isUnitOrBaseUnitSelected(unit, $(unitSelect)));
    });

    this.updateAvailableBillingAndGroupOrderUnits();
  }

  findAboveUnit(row$) {
    const previousRow$ = row$.prev();
    if (previousRow$.length > 0) {
      const unitKey = previousRow$.find('select[name$="[unit]"]').val();
      const unit = this.availableUnits.find(availableUnit => availableUnit.key === unitKey);
      if (!unit) {
        return '?';
      }
      return unit.label;
    } else {
      const unitKey = this.supplierUnitSelect$.val();
      if (unitKey !== '') {
        const unit = this.availableUnits.find(availableUnit => availableUnit.key === unitKey);
        if (!unit) {
          return '?';
        }
        return unit.label;
      } else {
        return this.unit$.val();
      }
    }
  }

  updateAvailableBillingAndGroupOrderUnits() {
    const unitsSelectedAbove = [];
    if (this.supplierUnitSelect$.val() != '') {
      const chosenOption$ = $(`option[value="${this.supplierUnitSelect$.val()}"]`, this.supplierUnitSelect$);
      unitsSelectedAbove.push({ key: chosenOption$.val(), label: chosenOption$.text() });
    } else {
      unitsSelectedAbove.push({ key: '', label: this.unit$.val() });
    }

    const selectedRatioUnits = $('tr select[name$="[unit]"]', this.unitRatiosTable$).map((_, ratioSelect) => ({
      key: $(ratioSelect).val(),
      label: $(`option[value="${$(ratioSelect).val()}"]`, ratioSelect).text()
    }))
      .get()
      .filter(option => option.key !== '');

    unitsSelectedAbove.push(...selectedRatioUnits);

    const availableUnits = [];
    for (const unitSelectedAbove of unitsSelectedAbove) {
      availableUnits.push(unitSelectedAbove, ...this.availableUnits.filter(availableUnit => {
        if (availableUnit.key === unitSelectedAbove.key) {
          return false;
        }

        const otherUnit = this.availableUnits.find(unit => unit.key === unitSelectedAbove.key);
        return otherUnit !== undefined && otherUnit.baseUnit !== null && availableUnit.baseUnit === otherUnit.baseUnit;
      }));
    }

    this.updateUnitsInSelect(availableUnits, this.billingUnit$);
    this.updateUnitsInSelect(availableUnits, this.groupOrderUnit$);
    this.updateUnitsInSelect(availableUnits, this.priceUnit$);
  }

  updateUnitsInSelect(units, unitSelect$) {
    const valueBeforeUpdate = unitSelect$.val();

    unitSelect$.empty();
    for (const unit of units) {
      unitSelect$.append($(`<option value="${unit.key}">${unit.label}</option>`));
    }

    const initialValue = unitSelect$.attr('data-initial-value');
    if (initialValue) {
      unitSelect$.val(initialValue);
      unitSelect$.removeAttr('data-initial-value');
    } else {
      if (unitSelect$.find(`option[value="${valueBeforeUpdate}"]`).length > 0) {
        unitSelect$.val(valueBeforeUpdate);
      } else {
        unitSelect$.val(unitSelect$.find('option:first').val());
      }
    }

    unitSelect$.trigger('change');
  }

  setFieldVisibility() {
    const firstUnitRatioQuantity$ = $('tr input[name$="[quantity]"]:first', this.unitRatiosTable$);
    const firstUnitRatioUnit$ = $('tr select[name$="[unit]"]:first', this.unitRatiosTable$);

    const supplierOrderUnitSet = !!this.unit$.val() || !!this.supplierUnitSelect$.val();
    const unitRationsVisible = supplierOrderUnitSet;
    this.unitRatiosTable$.parents('.fold-line').toggle(unitRationsVisible);

    if (!unitRationsVisible) {
      $('tbody tr', this.unitRatiosTable$).remove();
    }

    const firstUnitRatioSet = !!firstUnitRatioQuantity$.val() && !!firstUnitRatioUnit$.val();
    const billingUnitAndGroupOrderUnitVisible = unitRationsVisible && firstUnitRatioSet;

    mergeJQueryObjects([
      this.billingUnit$,
      this.groupOrderUnit$
    ]).parents('.fold-line').toggle(billingUnitAndGroupOrderUnitVisible);

    if (!billingUnitAndGroupOrderUnitVisible) {
      mergeJQueryObjects([this.billingUnit$, this.groupOrderUnit$]).val('');
    }

    mergeJQueryObjects([
      this.unit$,
      this.supplierUnitSelect$,
      firstUnitRatioQuantity$,
      firstUnitRatioUnit$
    ]).off('change.article_form_visibility')
      .on('change.article_form_visibility', () =>
        this.setFieldVisibility()
      );

    firstUnitRatioQuantity$
      .off('keyup.article_form_visibility')
      .on('keyup.article_form_visibility', () => firstUnitRatioQuantity$.trigger('change'));
  }

  prepareRatioDataForSequentialRepresentation() {
    const numberOfRatios = $(`input[name^="${this.unitFieldsPrefix}[article_unit_ratios_attributes]"][name$="[quantity]"]`).length;

    for (let i = numberOfRatios; i > 1; i--) {
      const currentField$ = $(`input[name="${ratioQuantityFieldNameByIndex(i)}"]`, this.articleForm$);
      const currentValue = currentField$.val();
      const previousValue = $(`input[name="${ratioQuantityFieldNameByIndex(i - 1)}"]:last`, this.articleForm$).val();
      currentField$.val(currentValue / previousValue);
    }
  }

  convertPriceToPriceUnit() {
    const groupOrderUnitPrice = this.price$.val();
    const ratio = this.getUnitRatio(1, this.priceUnit$.val(), this.groupOrderUnit$.val());
    const relativePrice = groupOrderUnitPrice * ratio;
    this.price$.val(relativePrice);
  }

  initializeOrderedAndReceivedUnits() {
    this.billingUnit$.change(() => {
      this.updateOrderedAndReceivedUnits();
      this.initializeOrderedAndReceivedUnitsConverters();
    });
    this.billingUnit$.trigger('change');
  }

  updateOrderedAndReceivedUnits() {
    const billingUnitKey = this.billingUnit$.val();
    const billingUnitLabel = this.getUnitLabel(billingUnitKey);
    const inputs$ = mergeJQueryObjects([this.unitsToOrder$, this.unitsReceived$]);
    inputs$.parent().find('.unit_label').remove();
    if (billingUnitLabel.trim() !== '') {
      inputs$.after($(`<span class="unit_label ml-1">x ${billingUnitLabel}</span>`));
    }
    if (this.previousBillingUnit !== undefined) {
      this.convertOrderedAndReceivedUnits(this.previousBillingUnit, billingUnitKey);
    }
    this.previousBillingUnit = billingUnitKey;
  }

  convertOrderedAndReceivedUnits(fromUnit, toUnit) {
    const inputs$ = mergeJQueryObjects([this.unitsToOrder$, this.unitsReceived$]);
    inputs$.each((_, input) => {
      const input$ = $(input);
      const convertedValue = this.getUnitRatio(input$.val(), fromUnit, toUnit);
      input$.val(convertedValue);
    });
  }

  initializeOrderedAndReceivedUnitsConverters() {
    this.unitsToOrder$.unitConversionField('destroy');
    this.unitsReceived$.unitConversionField('destroy');

    const opts = {
      units: this.units,
      popoverTemplate$: this.unitConversionPopoverTemplate$,
      ratios: this.ratios,
      supplierOrderUnit: this.supplierUnitSelect$.val(),
      customUnit: this.unit$.val(),
      defaultUnit: this.billingUnit$.val()
    };
    this.unitsToOrder$.unitConversionField(opts);
    this.unitsReceived$.unitConversionField(opts);
  }

  loadRatios() {
    this.ratios = [];
    this.unitRatiosTable$.find('tbody tr').each((_, element) => {
      const tr$ = $(element);
      const unit = tr$.find(`select[name^="${this.unitFieldsPrefix}[article_unit_ratios_attributes]"][name$="[unit]"]`).val();
      const quantity = tr$.find(`input[name^="${this.unitFieldsPrefix}[article_unit_ratios_attributes]"][name$="[quantity]"]:last`).val();
      this.ratios.push({ unit, quantity });
    });
  }

  undoSequentialRatioDataRepresentation() {
    let previousValue;
    $(`input[name^="${this.unitFieldsPrefix}[article_unit_ratios_attributes]"][name$="[quantity]"]`).each((_, field) => {
      let currentField$ = $(field);
      let quantity = currentField$.val();

      if (previousValue !== undefined) {
        const td$ = currentField$.parents('td');
        const name = currentField$.attr('name');
        const ratioNameRegex = new RegExp(`${this.unitFieldsPrefix}\\[article_unit_ratios_attributes\\]\\[([0-9]+)\\]`);
        const index = name.match(ratioNameRegex)[1];
        quantity = quantity * previousValue;
        currentField$ = $(`<input type="hidden" name="${ratioQuantityFieldNameByIndex(index)}" value="${quantity}" />`);
        td$.append(currentField$);
      }

      previousValue = quantity;
    });
  }
}

function ratioQuantityFieldNameByIndex(i) {
  return `${this.unitFieldsPrefix}[article_unit_ratios_attributes][${i}][quantity]`;
}


function mergeJQueryObjects(array_of_jquery_objects) {
  return $($.map(array_of_jquery_objects, function (el) {
    return el.get();
  }));
}
