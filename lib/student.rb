require 'pry'
class Student
  attr_reader :id
  attr_accessor :name, :grade
  @@all = []

  def initialize(name,grade)
    @name = name
    @grade = grade
    @@all << self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL
    students = DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students;
    SQL

    DB[:conn].execute(sql)

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name,grade)
      VALUES (?,?);
    SQL

    DB[:conn].execute(sql,self.name,self.grade)

    @id = DB[:conn].execute("SELECT * FROM students").last[0]
  end

  def self.create(name:,grade:)
    new_student = Student.new(@name, @grade)
    new_student.save
    new_student
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

end
