require 'sinatra'
require_relative 'Banco.rb'

configure do
  set :public_folder, File.join(File.dirname(__FILE__), 'public')
  set :bd, Banco.new
  set :user, nil
end

get '/' do
  erb :login, layout: :layout
end

post '/login' do
  dados = settings.bd.ler('usuarios')
  user = params[:email]
  key = params[:password]
  dados.each do |ids, users, keys|
    if users == user && keys == key
      settings.user = users
      redirect '/home'
    end
  end
  redirect '/'
end

post '/cadastro' do
  user = params[:email]
  key = params[:password]
  if settings.bd.cadastro(user,key)
    redirect '/?ack=cadastro_concluido'
  else
    redirect '/?erro=usuario_existente'
  end
end

post '/tarefa' do
  user = settings.user
  nome = params[:tafera]
  settings.bd.tarefa_new(user,nome)
  redirect '/home'
end

get '/home' do
  redirect "/" if settings.user == nil
  @user = settings.user
  @tarefas = settings.bd.ler('tarefas')
  erb :index
end

post '/feito' do
  @user = settings.user
  tarefa = params[:tarefa]
  settings.bd.concluir(tarefa,@user)
  redirect '/home'
end
