require 'sqlite3'
require_relative 'config/env'

class Banco
  def initialize
    data_file = ENV['DATA_FILE']
    raise "Variável de ambiente DATA_FILE não definida" unless data_file

    @banco = SQLite3::Database.new(data_file)
    criar_tabelas
  end

  private

  def criar_tabelas
    @banco.execute <<-SQL
      CREATE TABLE IF NOT EXISTS usuarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT UNIQUE NOT NULL,
          senha TEXT NOT NULL
      );
    SQL

    @banco.execute <<-SQL
      CREATE TABLE IF NOT EXISTS tarefas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nome TEXT NOT NULL,
          feita BOOLEAN NOT NULL DEFAULT 0,
          data DATE DEFAULT CURRENT_TIMESTAMP,
          dono INTEGER,
          FOREIGN KEY (dono) REFERENCES usuarios(id)
      );
    SQL
  end

  public

  def cadastro(email,senha)
    begin
      @banco.execute('INSERT INTO usuarios (email,senha) VALUES (?,?)',[email,senha])
      return true
      rescue SQLite3::Exception => e
      puts "Erro ao cadastrar usuário: #{e.message}"
    end
  end

  def ler(tabela)
    begin
      dados = @banco.execute("SELECT * FROM #{tabela}")
      return dados
    rescue SQLite3::Exception => e
      puts "Erro ao ler a tabela: #{e.message}"
      return false
    end
  end

  def tarefa_new(user,nome)
    begin
      @banco.execute("INSERT INTO tarefas (dono,nome) VALUES (?,?)",[user,nome])
      return true
    rescue SQLite3::Exception => e
      puts "Erro cadastrar tarefa #{e.message}"
      return false
    end
  end

  def concluir(nome,user)
    begin
      @banco.execute("UPDATE tarefas SET feita = 1 WHERE nome = ? AND dono = ?",[nome,user])
      return true
    rescue SQLite3::Exception => e
      puts "Erro concluir tarefa #{e.message}"
      return false
    end
  end
end

if __FILE__ == $0
  puts "Criando banco de dados..."
  Banco.new
  puts "Banco de dados criado com sucesso."
end
