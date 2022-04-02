class UnitConversionField {
  constructor(field$, units, popoverTemplate$) {
    this.field$ = field$;
    // TODO: not very clean and not jquery-esque:
    this.field$[0].unitConversionField = this;
    this.popoverTemplate = popoverTemplate$[0].content.querySelector('.popover_contents');
    this.units = units;

    this.loadArticleUnitRatios();
    this.initializeFocusListener();
  }

  loadArticleUnitRatios() {
    this.ratios = [];
    for (let i = 0; this.field$.data(`ratio-quantity-${i}`) !== undefined; i++) {
      this.ratios.push({
        quantity: this.field$.data(`ratio-quantity-${i}`),
        unit: this.field$.data(`ratio-unit-${i}`),
      });
    }

    this.supplierOrderUnit = this.field$.data('supplier-order-unit');
    this.customUnit = this.field$.data('custom-unit');
    this.defaultUnit = this.field$.data('default-unit');
  }

  initializeFocusListener() {
    this.field$.popover({title: 'Conversions', placement: 'bottom', trigger: 'manual'});

    this.field$.focus(() => this.field$.popover('show'));

    this.field$.on('shown.bs.popover', () => this.initializeConversionPopover(this.field$.next('.popover')));
  }

  initializeConversionPopover(popover$) {
    let showAgainHack = false;
    if (!popover$.hasClass('wide')) {
      popover$.addClass('wide');
      showAgainHack = true;
    }

    const popoverContent$ = popover$.find('.popover-content');
    popoverContent$.empty();

    const contents$ = $(document.importNode(this.popoverTemplate, true));
    popoverContent$.append(contents$);

    if (showAgainHack) {
      this.field$.popover('show');
      return;
    }

    this.quantityInput$ = contents$.find('input.quantity');
    this.quantityInput$.val(this.field$.val());
    this.unitSelect$ = contents$.find('select.unit');
    const unitSelectOptions = this.getUnitSelectOptions();
    this.unitSelect$.append(unitSelectOptions.map(option => $(`<option value${option.value === undefined ? '' : `="${option.value}"`}>${option.label}</option>`)))
    let initialUnitSelectValue = this.defaultUnit;
    if (initialUnitSelectValue === undefined) {
      initialUnitSelectValue = unitSelectOptions[0].value;
    }
    this.unitSelect$.val(initialUnitSelectValue);

    this.previousUnitSelectValue = convertEmptyStringToUndefined(this.unitSelect$.val());

    this.unitSelect$.change(() => this.onUnitSelectChanged());

    contents$.find('input.cancel').click(() => this.field$.popover('hide'));
    contents$.find('input.apply').click(() => {
      this.applyConversion();
      this.field$.popover('hide');
    });
  }

  getUnitSelectOptions() {
    const options = [];
    const unit = this.units[this.supplierOrderUnit];
    options.push({
      value: this.supplierOrderUnit,
      label: unit === undefined ? this.customUnit : unit.name
    })

    for (const ratio of this.ratios) {
      options.push({
        value: ratio.unit,
        label: this.units[ratio.unit].name
      });

      options.push(
        ...Object.entries(this.units)
        .filter(([unitId, unit]) => unit.visible && unit.baseUnit !== null && unit.baseUnit === this.units[ratio.unit].baseUnit && unitId !== ratio.unit)
        .map(([unitId, unit]) => ({
          value: unitId,
          label: unit.name
        }))
      );
    }

    return options;
  }

  getUnitQuantity(unitId) {
    if (unitId === this.supplierOrderUnit) {
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

  applyConversion() {
    const newValue = this.getUnitRatio(this.quantityInput$.val(), this.unitSelect$.val(), this.defaultUnit === undefined ? this.supplierOrderUnit : this.defaultUnit);
    this.field$.val(newValue);
  }

  onUnitSelectChanged() {
    const newValue = this.getUnitRatio(this.quantityInput$.val(), this.previousUnitSelectValue, convertEmptyStringToUndefined(this.unitSelect$.val()));
    this.quantityInput$.val(newValue);

    this.previousUnitSelectValue = convertEmptyStringToUndefined(this.unitSelect$.val());
  }
}

function convertEmptyStringToUndefined(str) {
  if (str === '') {
    return undefined;
  }

  return str;
}
