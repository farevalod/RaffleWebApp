class ApplicationController < ActionController::Base
  before_action :authorize
  # after_action :set_last_page_visited
  protect_from_forgery with: :exception

  protected

  def authorize
    unless Seller.find_by(id: session[:user_id]) or Admin.find_by(id: session[:admin_id])
      redirect_to main_page_url, notice: "Please log in"
    end
  end

  def authorize_admin
    unless Admin.find_by(id: session[:admin_id])
      redirect_to seller_url(session[:user_id]), notice: "Necesitas permisos de administrador de institución"
      # El caso en el que no es un usuario esta cubiero por authorize
    end
  end

  def authorize_seller_s_admin
    admin = Admin.find_by(id: session[:admin_id])
    if admin
      if admin.admin_level == 3 or admin.admin_level == 4
        redirect_to institution_url(admin.institution.id), notice: "Los administrdores de instituciones no poseen boletos"
      end
    end
  end

  def authorize_super_admin
    admin = Admin.find_by(id: session[:admin_id])
    unless admin.admin_level == 1 or admin.admin_level == 2
      redirect_to institution_url(admin.institution.id)
    end
    # El caso en que no es un admin esta cubierto por authorize_admin
    # Si no hay sesión iniciada está cubierto por authorize
  end

  def set_last_page_visited
    session[:previous_page] = "#{request.original_url}"
  end

  def remove_accent_marks(prhase)
    prhase.tr( "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšȘșſŢţŤťŦŧȚțÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž", "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSsSssTtTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz")
  end

  def remove_non_alnum(phrase)
    #Permite caráctteres normales y con tilde latina (las demás tildes son eliminadas)
    phrase.gsub(/[^0-9a-záéíóúÁÉÍÓÚ\\s]/i, '')
  end

  def remove_non_numeric(phrase)
    phrase.gsub(/[^0-9]/i, '')
  end

  def rut_formatter(rut)
    only_num = remove_non_numeric(rut)
    only_num[0..-8] + '.' + only_num[-7..-5] + '.' + only_num[-4..-2] + '-' + only_num[-1]
  end

end
