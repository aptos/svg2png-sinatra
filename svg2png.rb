# coding: utf-8
require 'sinatra'
require 'rsvg2'
require 'haml'

get '/' do
  haml :index
end

post '/result' do
  if params[:file]
    svg_data = params[:file][:tempfile].read
    png_data = ImageConvert.svg_to_png(svg_data, params[:width].to_i, params[:height].to_i)
  else
  end
  content_type 'png'
  png_data
end

class ImageConvert
  def self.svg_to_png(svg, width, height)
    svg = RSVG::Handle.new_from_data(svg)
    width   = width  ||=500
    height  = height ||=500
    surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, width, height)
    context = Cairo::Context.new(surface)
    context.render_rsvg_handle(svg)
    b = StringIO.new
    surface.write_to_png(b)
    return b.string
  end
end
