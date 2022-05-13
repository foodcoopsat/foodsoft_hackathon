class ArticleForm {
  constructor(articleUnitRatioTemplate$, articleForm$, units) {
    try {
      this.units = units;
      this.articleUnitRatioTemplate$ = articleUnitRatioTemplate$;
      this.articleForm$ = articleForm$;
      this.unit$ = $('#article_unit', this.articleForm$);
      this.supplierUnitSelect$ = $('#article_supplier_order_unit', this.articleForm$);
      this.unitRatiosTable$ = $('#fc_base_price', this.articleForm$);
      this.minimumOrderQuantity$ = $('#article_minimum_order_quantity', this.articleForm$);
      this.billingUnit$ = $('#article_billing_unit', this.articleForm$);
      this.groupOrderUnit$ = $('#article_group_order_unit', this.articleForm$);
      this.price$ = $('#article_price', this.articleForm$);
      this.priceUnit$ = $('#article_price_unit', this.articleForm$);
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
      this.initializeFormSubmitListener();
    } catch(e) {
      console.log('Could not initialize article form', e);
    }
  }

  initializeFormSubmitListener() {
    this.articleForm$.submit(() => {
      this.undoSequentialRatioDataRepresentation();
      this.loadRatios();
      this.undoPriceConversion();
    });
  }

  // TODO: Code duplication with unit conversion field:
  getUnitQuantity(unitId) {
    if (unitId === this.supplierUnitSelect$.val()) {
      return 1;
    }

    const ratio = this.ratios.find(ratio => ratio.unit === unitId);
    if (ratio !== undefined) {
      return ratio.quantity;
    }

    const unit = this.units[unitId];
    const relatedRatio = this.ratios.find(ratio => this.units[ratio.unit].baseUnit === unit.baseUnit);
    const relatedUnit = this.units[relatedRatio.unit];
    return relatedRatio.quantity / unit.conversionFactor * relatedUnit.conversionFactor;
  }

  getUnitRatio(quantity, inputUnit, outputUnit) {
    return quantity / this.getUnitQuantity(inputUnit) * this.getUnitQuantity(outputUnit);
  }

  undoPriceConversion() {
    const relativePrice = this.price$.val();
    const ratio = this.getUnitRatio(1, this.priceUnit$.val(), this.groupOrderUnit$.val());
    const groupOrderUnitPrice = relativePrice / ratio;
    const hiddenPriceField$ = $(`<input type="hidden" name="${this.price$.attr('name')}" value="${groupOrderUnitPrice}" />`);
    this.articleForm$.append(hiddenPriceField$);
  }

  loadAvailableUnits() {
    this.availableUnits = Object.entries(this.units)
      .filter(([, unit]) => unit.visible)
      .map(([code, unit]) => ({key: code, label: unit.name, baseUnit: unit.baseUnit}));

    $('#article_supplier_order_unit', this.articleForm$).select2(this.select2Config);
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
    const unitVal = $('#article_unit').val();
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

    const index = $('input[name^="article[article_unit_ratios_attributes]"][name$="[sort]"]', this.articleForm$).length
      + $('input[name^="article[article_unit_ratios_attributes]"][name$="[_destroy]"]', this.articleForm$).length;

    const sortField$ = $('[name$="[sort]"]', newRow$);
    sortField$.val(index);

    const ratioAttributeFields$ = $('[id^="article_article_unit_ratios_attributes_0_"]', newRow$);
    ratioAttributeFields$.each((_, field) => {
      $(field).attr('name', $(field).attr('name').replace('[0]', `[${index}]`));
      $(field).attr('id', $(field).attr('id').replace('article_article_unit_ratios_attributes_0_', `article_article_unit_ratios_attributes_${index}_`));
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
    const id = $(`[name="article[article_unit_ratios_attributes][${index}][id]"]`, this.articleForm$).val();
    row$.remove();

    $(this.unitRatiosTable$).after($(`<input type="hidden" name="article[article_unit_ratios_attributes][${index}][_destroy]" value="true">`));
    $(this.unitRatiosTable$).after($(`<input type="hidden" name="article[article_unit_ratios_attributes][${index}][id]" value="${id}">`));
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
      unitsSelectedAbove.push({key: chosenOption$.val(), label: chosenOption$.text()});
    } else {
      unitsSelectedAbove.push({key: '', label: this.unit$.val()});
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
      availableUnits.push(unitSelectedAbove, ...this.availableUnits.filter(unit =>
        unit.key !== unitSelectedAbove.key && unit.baseUnit === unitSelectedAbove.key
      ));
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
    const numberOfRatios = $(`input[name^="article[article_unit_ratios_attributes]"][name$="[quantity]"]`).length;

    for (let i = numberOfRatios; i > 1; i--) {
      const currentField$ = $(`input[name="${ratioQuantityFieldNameByIndex(i)}"]`, this.articleForm$);
      const currentValue = currentField$.val();
      const previousValue = $(`input[name="${ratioQuantityFieldNameByIndex(i-1)}"]:last`, this.articleForm$).val();
      currentField$.val(currentValue / previousValue);
    }
  }

  convertPriceToPriceUnit() {
    const groupOrderUnitPrice = this.price$.val();
    const ratio = this.getUnitRatio(1, this.priceUnit$.val(), this.groupOrderUnit$.val());
    const relativePrice = groupOrderUnitPrice * ratio;
    this.price$.val(relativePrice);
  }

  loadRatios() {
    this.ratios = [];
    this.unitRatiosTable$.find('tr').each((_, element) => {
      const tr$ = $(element);
      const unit = tr$.find(`select[name^="article[article_unit_ratios_attributes]"][name$="[unit]"]`).val();
      const quantity = tr$.find(`input[name^="article[article_unit_ratios_attributes]"][name$="[quantity]"]:last`).val();
      this.ratios.push({unit, quantity});
    });
  }

  undoSequentialRatioDataRepresentation() {
    let previousValue;
    $(`input[name^="article[article_unit_ratios_attributes]"][name$="[quantity]"]`).each((_, field) => {
      let currentField$ = $(field);
      let quantity = currentField$.val();

      if (previousValue !== undefined) {
        const td$ = currentField$.parents('td');
        const name = currentField$.attr('name');
        const index = name.match(/article\[article_unit_ratios_attributes\]\[([0-9]+)\]/)[1];
        quantity = quantity * previousValue;
        currentField$ = $(`<input type="hidden" name="${ratioQuantityFieldNameByIndex(index)}" value="${quantity}" />`);
        td$.append(currentField$);
      }

      previousValue = quantity;
    });
  }
}

function ratioQuantityFieldNameByIndex(i) {
  return `article[article_unit_ratios_attributes][${i}][quantity]`;
}


function mergeJQueryObjects(array_of_jquery_objects) {
  return $($.map(array_of_jquery_objects, function(el) {
      return el.get();
  }));
}
