class SetUserService
  IMPORT_COLUMNS = %w(name email address)
  def initialize file
    @file = file
  end

  def import
    user_success = Settings.start_count
    user_update = Settings.start_count
    user_failed = Settings.start_count
    spreadsheet = open_spreadsheet
    return I18n.t "failed_to_read_file" unless spreadsheet
    header = spreadsheet.row Settings.row_header
    (Settings.row_user_start..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = User.find_by email: row["email"]
      if user.present?
        unless user.address == row["address"]
          user.update_attribute :address, row["address"]
          user_update += Settings.user_increase
        end
      else
        user = User.new row.to_hash.slice(*IMPORT_COLUMNS)
        user.password = (0...8).map {(65 + rand(26)).chr}.join
        user.password_confirmation = user.password
        user.authentication_token = Devise.friendly_token
        if user.save
          password = user.password
          ContactRequestMailer.delay.to_user(user, password)
          user_success += Settings.user_increase
        else
          user_failed += Settings.user_increase
        end
      end
    end
    flash = ""
    flash += I18n.t("import_add_user_success", num: user_success) if user_success > Settings.start_count
    flash += I18n.t("import_update_user_success", num: user_update) if user_update > Settings.start_count
    flash += I18n.t("import_user_faild", num: user_failed) if user_failed > Settings.start_count
    flash
  end

  private
  def open_spreadsheet
    case File.extname @file.original_filename
    when Settings.file_xls
      Roo::Excel.new @file.path, file_warning: :ignore
    when Settings.file_xlsx
      Roo::Excelx.new @file.path, file_warning: :ignore
    else
      nil
    end
  end
end
