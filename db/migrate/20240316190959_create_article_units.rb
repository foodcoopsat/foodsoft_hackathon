class CreateArticleUnits < ActiveRecord::Migration[5.2]
  def up
    create_table :article_units, id: false do |t|
      t.string :unit, length: 3, null: false

      t.timestamps
    end

    add_index :article_units, :unit, unique: true

    piece_unit_codes = %w[XCU XCN XSH X43 XST XOK XVA XBX XBH XBE XCX XBJ XUN XOS XDH XBA XFI XBO XBQ XFB XFT XJR XGR XOW X8B XCV XWA XEI XJT XGY XJY XBD XCR XAI XPA XBK XBI XOV XNT XPK XPC XPX X5M XPR XEC X6H X44 XBR XCW XBT XSA XBM XSX XDN XAE XSC XLU X5L XPP XBG XP2 XCK XGI XTU XPU XPT PTN STC]
    scalar_unit_codes = %w[DMT CMT 4H MMT HMT KMT A45 MTK DAA KMK CMK DMK H16 H18 MMK ARE HAR YDK KGM HGM KTN DJ DG CGM DTN MGM 2U MC GRM TNE M86 SEC MIN HUR DAY C26 WEE MON ANN MTQ LTR MAL DLT 4G K6 A44 MMQ CMQ DMQ MLT HLT CLT DMA H19 H20 M70 YDQ G26 G21 G24 G25 JOU J75 K51 J55 WHR KWH GWH WTT KWT MAW]

    imperial_scalar_unit_codes = %w[INH FOT YRD SMI 5I 77 M47 INK FTK MIK ACR LBR GRN ONZ CWI CWA LTN STI STN APZ F13 M67 M68 M69 INQ FTQ GLI GLL PTI QTI PTL QTL PTD OZI J57 L43 L84 L86 OZA BUI BUA BLL BLD GLD QTD G23]

    unit_codes = piece_unit_codes + scalar_unit_codes

    unit_codes += imperial_scalar_unit_codes if imperial_plain_text_units_exist?

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

  protected

  def imperial_plain_text_units_exist?
    plain_text_units = select_all('SELECT DISTINCT unit FROM article_versions').pluck('unit')
    plain_text_units.any? { |plain_text_unit| /(?:\s|[0-9])+(?:oz|lb)\s*$/.match(plain_text_unit) }
  end
end
