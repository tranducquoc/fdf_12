class PdfReadersController < ApplicationController
  def index
    pdf_filename = File.join(Rails.root, "public/manual.pdf")
    send_file(pdf_filename, filename: "manual.pdf",
      disposition: 'inline', type: "application/pdf")
  end
end
