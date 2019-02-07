class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
          id INTEGER PRIMARY KEY
        , name TEXT
        , grade TEXT
      )
      SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
      SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("select * from students").last[0]
  end

  def self.create(name:, grade:)
    new_stud = Student.new(name, grade)
    new_stud.save
    new_stud
  end
end
