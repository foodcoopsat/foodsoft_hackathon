require_relative '../../spec/spec_helper'
require_relative '../migrate/20221026102301_alter_articles_add_more_unit_logic'

describe AlterArticlesAddMoreUnitLogic do
  migration = nil
  before do
    migration = described_class.new
  end

  it 'converts "kg" correctly' do
    result = migration.send(:convert_old_unit, 'kg', 1)
    expect(result).to eq({
                           supplier_order_unit: 'KGM',
                           first_ratio: nil,
                           group_order_granularity: 1,
                           group_order_unit: 'KGM'
                         })
  end

  it 'converts "250g" correctly' do
    result = migration.send(:convert_old_unit, '250g', 1)
    expect(result).to eq({
                           supplier_order_unit: 'XPP',
                           first_ratio: {
                             unit: 'GRM',
                             quantity: 250.0
                           },
                           group_order_granularity: 1.0,
                           group_order_unit: 'XPP'
                         })
  end

  it 'converts "1/4 kg" correctly' do
    result = migration.send(:convert_old_unit, '1/4 kg', 1)
    expect(result).to eq({
                           supplier_order_unit: 'XPP',
                           first_ratio: {
                             unit: 'KGM',
                             quantity: 0.25
                           },
                           group_order_granularity: 1.0,
                           group_order_unit: 'XPP'
                         })
  end

  it 'converts "bunch" correctly' do
    result = migration.send(:convert_old_unit, 'bunch', 1)
    expect(result).to eq({
                           supplier_order_unit: 'XBH',
                           first_ratio: nil,
                           group_order_granularity: 1.0,
                           group_order_unit: 'XBH'
                         })
  end

  it 'converts "glass" correctly' do
    result = migration.send(:convert_old_unit, 'glass', 1)
    expect(result).to eq({
                           supplier_order_unit: 'XGR',
                           first_ratio: nil,
                           group_order_granularity: 1.0,
                           group_order_unit: 'XGR'
                         })
  end

  it 'converts "piece" correctly' do
    result = migration.send(:convert_old_unit, 'piece', 1)
    expect(result).to eq({
                           supplier_order_unit: 'XPP',
                           first_ratio: nil,
                           group_order_granularity: 1.0,
                           group_order_unit: 'XPP'
                         })
  end

  it 'converts "4 piece" correctly' do
    result = migration.send(:convert_old_unit, '4 piece', 1)
    expect(result).to eq({
                           supplier_order_unit: 'XPK',
                           first_ratio: {
                             unit: 'XPP',
                             quantity: 4
                           },
                           group_order_granularity: 1.0,
                           group_order_unit: 'XPK'
                         })
  end

  it 'converts "1 bunch" correctly' do
    result = migration.send(:convert_old_unit, '1 bunch', 1)
    expect(result).to eq({
                           supplier_order_unit: 'XBH',
                           first_ratio: nil,
                           group_order_granularity: 1.0,
                           group_order_unit: 'XBH'
                         })
  end

  it 'converts "2 bunch" correctly' do
    result = migration.send(:convert_old_unit, '2 bunch', 1)
    expect(result).to eq({
                           supplier_order_unit: 'XPK',
                           first_ratio: {
                             unit: 'XBH',
                             quantity: 2
                           },
                           group_order_granularity: 1.0,
                           group_order_unit: 'XPK'
                         })
  end

  it 'converts "4x250g" correctly' do
    result = migration.send(:convert_old_unit, '250g', 4)
    expect(result).to eq({
                           supplier_order_unit: 'XPP',
                           first_ratio: {
                             unit: 'GRM',
                             quantity: 1000
                           },
                           group_order_granularity: 250,
                           group_order_unit: 'GRM'
                         })
  end

  it 'converts "6 x glass" correctly' do
    result = migration.send(:convert_old_unit, 'glass', 6)
    expect(result).to eq({
                           supplier_order_unit: 'XPK',
                           first_ratio: {
                             unit: 'XGR',
                             quantity: 6
                           },
                           group_order_granularity: 1,
                           group_order_unit: 'XGR'
                         })
  end

  it 'fails to convert "12 nonesense"' do
    result = migration.send(:convert_old_unit, '12 nonesense', 1)
    expect(result).to eq(nil)
  end
end
