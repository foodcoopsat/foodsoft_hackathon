class UnitConversionField {
  constructor(field$, units, popoverTemplate$) {
    this.field$ = field$;
    this.popoverTemplate = popoverTemplate$[0].content.querySelector('.popover_contents');
    this.units = units;

    this.loadArticleUnitRatios();
    this.initializeFocusListener();
  }

  loadArticleUnitRatios() {
    this.ratios = [];
    for (let i = 0; this.field$.attr(`data-ratio-quantity-${i}`) !== undefined; i++) {
      this.ratios.push({
        quantity: this.field$.attr(`data-ratio-quantity-${i}`),
        unit: this.field$.attr(`data-ratio-unit-${i}`),
      });
    }

    this.supplierOrderUnit = this.field$.attr('data-supplier-order-unit');
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
    this.unitSelect$.append(this.getUnitSelectOptions().map(option => $(`<option value="${option.value}">${option.label}</option>`)))

    contents$.find('input.cancel').click(() => this.field$.popover('hide'));
    contents$.find('input.apply').click(() => {
      this.applyConversion();
      this.field$.popover('hide');
    });
  }

  getUnitSelectOptions() {
    const options = [];
    options.push({
      value: this.supplierOrderUnit,
      label: this.units[this.supplierOrderUnit].name
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
    const newValue = this.getUnitRatio(this.quantityInput$.val(),  this.unitSelect$.val(), this.supplierOrderUnit);
    this.field$.val(newValue);
  }
}
