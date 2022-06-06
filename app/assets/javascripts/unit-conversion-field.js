class UnitConversionField {
  constructor(field$, units, popoverTemplate$, useTargetUnitForStep = true) {
    this.field$ = field$;
    // TODO: not very clean and not jquery-esque:
    this.field$[0].unitConversionField = this;
    this.popoverTemplate = popoverTemplate$[0].content.querySelector('.popover_contents');
    this.units = units;
    this.useTargetUnitForStep = useTargetUnitForStep;

    this.loadArticleUnitRatios();

    // if every ratio is the same, don't even bother showing the popover:
    if (this.ratios.every(ratio => ratio.quantity === 1)) {
      return;
    }

    this.converter = new UnitsConverter(this.units, this.ratios, this.supplierOrderUnit);

    this.initializeFocusListener();
  }

  loadArticleUnitRatios() {
    this.ratios = [];
    for (let i = 0; this.field$.data(`ratio-quantity-${i}`) !== undefined; i++) {
      this.ratios.push({
        quantity: parseFloat(this.field$.data(`ratio-quantity-${i}`)),
        unit: this.field$.data(`ratio-unit-${i}`),
      });
    }

    this.supplierOrderUnit = this.field$.data('supplier-order-unit');
    this.customUnit = this.field$.data('custom-unit');
    this.defaultUnit = this.field$.data('default-unit');
  }

  initializeFocusListener() {
    this.field$.popover({title: 'Conversions', placement: 'bottom', trigger: 'manual'});

    this.field$.focus(() => this.openPopover());

    this.field$.on('shown.bs.popover', () => this.initializeConversionPopover(this.field$.next('.popover')));
  }

  openPopover() {
    $(document).on('mousedown.unit-conversion-field', (e) => {
      if ($(e.target).parents('.popover').length !== 0 || e.target === this.field$[0]) {
        return;
      }

      this.closePopover();
    });
    this.field$.popover('show');
  }

  closePopover() {
    $(document).off('mousedown.unit-conversion-field');
    this.field$.off('change.unit-conversion-field');
    this.field$.popover('hide');
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
      this.openPopover();
      return;
    }

    this.quantityInput$ = contents$.find('input.quantity');
    this.quantityInput$.val(this.field$.val());
    this.conversionResult$ = contents$.find('.conversion-result');
    this.unitSelect$ = contents$.find('select.unit');
    this.unitSelectOptions = this.getUnitSelectOptions();
    this.unitSelect$.append(this.unitSelectOptions.map(option => $(`<option value${option.value === undefined ? '' : `="${option.value}"`}>${option.label}</option>`)))
    let initialUnitSelectValue = this.defaultUnit;
    if (initialUnitSelectValue === undefined) {
      initialUnitSelectValue = this.unitSelectOptions[0].value;
    }
    this.unitSelect$.val(initialUnitSelectValue);

    this.previousUnitSelectValue = convertEmptyStringToUndefined(this.unitSelect$.val());

    this.unitSelect$.change(() => this.onUnitSelectChanged());

    // eslint-disable-next-line no-undef
    mergeJQueryObjects([this.quantityInput$, this.unitSelect$]).change(() => this.showCurrentConversion())
    this.quantityInput$.keyup(() => this.quantityInput$.trigger('change'));
    this.showCurrentConversion();

    this.field$.on('change.unit-conversion-field', () => {
      this.quantityInput$.val(this.field$.val());
      this.unitSelect$.val(initialUnitSelectValue);
    });

    contents$.find('input.cancel').click(() => this.closePopover());
    contents$.find('input.apply').click(() => {
      this.applyConversion();
      this.closePopover();
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

  showCurrentConversion() {
    const unit = this.defaultUnit === undefined ? this.supplierOrderUnit : this.defaultUnit;
    const unitLabel = this.unitSelectOptions.find(option => option.value === unit).label;
    this.conversionResult$.text('= ' + this.getConversionResult() + ' x ' + unitLabel);
  }

  applyConversion() {
    this.field$
      .val(this.getConversionResult())
      .trigger('change');
  }

  getQuantityInputValue() {
    const val = parseFloat(this.quantityInput$.val().trim().replace(',', '.'));
    if (isNaN(val)) {
      return 0;
    }

    return val;
  }

  getTargetUnit() {
    return this.defaultUnit === undefined ? this.supplierOrderUnit : this.defaultUnit;
  }

  getConversionResult() {
    const result = this.converter.getUnitRatio(this.getQuantityInputValue(), convertEmptyStringToUndefined(this.unitSelect$.val()), this.getTargetUnit());
    return Math.round(result * 10000) / 10000;
  }

  onUnitSelectChanged() {
    const newValue = this.converter.getUnitRatio(this.getQuantityInputValue(), this.previousUnitSelectValue, convertEmptyStringToUndefined(this.unitSelect$.val()));
    this.quantityInput$.val(newValue);

    const selectedUnit = convertEmptyStringToUndefined(this.unitSelect$.val());
    this.previousUnitSelectValue = selectedUnit;

    const step = this.useTargetUnitForStep ? this.converter.getUnitRatio(1, this.getTargetUnit(), selectedUnit) : 0.001;
    this.quantityInput$.attr('step', step);
  }
}

function convertEmptyStringToUndefined(str) {
  if (str === '') {
    return undefined;
  }

  return str;
}
