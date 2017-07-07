class ImportGroupUserService
  IMPORT_COLUMNS = %w(email group)
  def initialize file
    @file = file
  end

  def import_group
    user_success = Settings.start_count
    user_failed = Settings.start_count
    spreadsheet = open_spreadsheet
    return I18n.t "failed_to_read_file" unless spreadsheet
    header = spreadsheet.row Settings.row_header
    (Settings.row_user_start..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = User.find_by email: row["email"]
      if user.present?
        user.update_attribute :address, row["group"]
        user_success += Settings.user_increase
      else
        user_failed += Settings.user_increase
      end
    end
    if (user_failed > Settings.start_count)
      user_failed.to_s + I18n.t("many_user") + user_success.to_s + I18n.t("import_success")
    else
      user_success.to_s + I18n.t("import_success")
    end
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
