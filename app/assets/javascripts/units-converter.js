class UnitsConverter {
  constructor(units, ratios, supplierOrderUnit) {
    this.units = units;
    this.ratios = ratios;
    this.supplierOrderUnit = supplierOrderUnit;
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
    if (relatedRatio !== undefined) {
      const relatedUnit = this.units[relatedRatio.unit];
      return relatedRatio.quantity / unit.conversionFactor * relatedUnit.conversionFactor;
    }

    const supplierOrderUnitConversionFactor = this.units[this.supplierOrderUnit].conversionFactor;
    return supplierOrderUnitConversionFactor / unit.conversionFactor;
  }

  getUnitRatio(quantity, inputUnit, outputUnit) {
    return quantity / this.getUnitQuantity(inputUnit) * this.getUnitQuantity(outputUnit);
  }

  isUnitSiConversible(unitId) {
    const unit = this.units[unitId];
    if (unit === undefined) {
      return false;
    }
    return !!unit.conversionFactor;
  }
}
