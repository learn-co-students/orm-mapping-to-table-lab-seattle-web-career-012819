class Student
  #DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id
  @@all = []

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id

    @@all << self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
          name TEXT,
          grade INTEGER);
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL

    DB[:conn].execute(sql, self.name, @grade)
    #binding.pry

    @id = DB[:conn].execute("SELECT id FROM students").last.last

  end

  def self.create(hash)
    #binding.pry
    student = Student.new(hash[:name], hash[:grade])
    student.save
    student
  end



end
