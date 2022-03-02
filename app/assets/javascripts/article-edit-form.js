class ArticleEditForm {
  constructor(articleUnitRatioTemplate$, articleForm$) {
    try {
      this.articleUnitRatioTemplate$ = articleUnitRatioTemplate$;
      this.articleForm$ = articleForm$;

      this.initializeRegularFormFields();

      this.initializeRatioRows();
      this.bindAddRatioButton();
    } catch(e) {
      console.log('Could not initialize article form', e);
    }
  }

  initializeRegularFormFields() {
    const unitInput$ = $('#article_unit');
    const supplierUnitSelect$ = $('#article_supplier_order_unit', this.articleForm$);
    supplierUnitSelect$.change(() => {
      unitInput$.prop('disabled', supplierUnitSelect$.val() !== undefined && supplierUnitSelect$.val().trim() !== '');
      this.filterAvailableRatioUnits();
    });
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
    $('#fc_base_price tbody', this.articleForm$).append(newRow$);

    const index = $('input[name^="article[article_unit_ratios_attributes]"][name$="[sort]"]', this.articleForm$).length
      + $('input[name^="article[article_unit_ratios_attributes]"][name$="[_destroy]"]', this.articleForm$).length
      + 1;

    const sortField$ = $('[name$="[sort]"]', newRow$);
    sortField$.val(index);

    const ratioAttributeFields$ = $('[id^="article_article_unit_ratios_attributes_0_"]', newRow$);
    ratioAttributeFields$.each((_, field) => {
      $(field).attr('name', $(field).attr('name').replace('[0]', `[${index}]`));
      $(field).attr('id', $(field).attr('id').replace('article_article_unit_ratios_attributes_0_', `article_article_unit_ratios_attributes_${index}_`));
    });

    this.initializeRatioRows();
  }

  initializeRatioRows() {
    $('#fc_base_price tr', this.articleForm$).each((_, row) => {
      this.initializeRatioRow($(row));
    });

    this.filterAvailableRatioUnits();
  }

  initializeRatioRow(row$) {
    $('*[data-remove-ratio]', row$).off('click').on('click', (e) => {
      e.preventDefault();
      e.stopPropagation();
      this.removeRatioRow($(e.target).parents('tr'));
    });

    $('select[name$="[unit]"]', row$).change(() => this.filterAvailableRatioUnits());
  }

  removeRatioRow(row$) {
    const index = row$.index() + 1;
    const id = $(`[name="article[article_unit_ratios_attributes][${index}][id]"]`, this.articleForm$).val();
    row$.remove();

    $('#fc_base_price', this.articleForm$).after($(`<input type="hidden" name="article[article_unit_ratios_attributes][${index}][_destroy]" value="true">`));
    $('#fc_base_price', this.articleForm$).after($(`<input type="hidden" name="article[article_unit_ratios_attributes][${index}][id]" value="${id}">`));
  }

  filterAvailableRatioUnits() {
    const supplierUnitSelect$ = $('#article_supplier_order_unit', this.articleForm$);
    let availableUnits = $('option', supplierUnitSelect$)
      .map((_, option) => ({key: option.value, label: option.innerText}))
      .get()
      .filter(value => value.key !== '');

    availableUnits = availableUnits.filter(unit => unit.key !== supplierUnitSelect$.val());

    $('#fc_base_price tr select[name$="[unit]"]', this.articleForm$).each((_, unitSelect) => {
      $('option[value!=""]' + availableUnits.map(unit => `[value!="${unit.key}"]`).join(''), unitSelect).remove();
      const missingUnits = availableUnits.filter(unit => $(`option[value="${unit.key}"]`, unitSelect).length === 0);
      for (const missingUnit of missingUnits) {
        $(unitSelect).append($(`<option value="${missingUnit.key}">${missingUnit.label}</option>`));
      }
      availableUnits = availableUnits.filter(unit => unit.key !== $(unitSelect).val());
    });
  }

}
