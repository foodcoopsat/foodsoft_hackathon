class CreateArticleUnits < ActiveRecord::Migration[5.2]
  def up
    create_table :article_units, id: false do |t|
      t.string :unit, length: 3, null: false

      t.timestamps
    end

    add_index :article_units, :unit, unique: true

    # TODO: modify list and make it scan current article units to determine, if metric, imperial or both unit types should be added
    # (see see https://github.com/foodcoopsat/foodsoft_hackathon/issues/35):
    unit_codes = %w[GRM HGM KGM LTR MLT PTN STC XPP XCR XBO XBH XGR XPK XSA XPU XPT]
    unit_codes.each do |unit_code|
      insert(%{
        INSERT INTO article_units (unit, created_at, updated_at)
        VALUES (
          #{quote unit_code},
          NOW(),
          NOW()
        )
      })
    end
  end

  def down
    drop_table :article_units
  end
end
