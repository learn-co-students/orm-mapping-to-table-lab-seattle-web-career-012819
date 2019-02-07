class Student
  attr_reader :id
  attr_accessor :name, :grade


  @@all = []
  def initialize(name, grade)#(id: null, name:, grade:)
    @id = nil #id
    @name = name
    @grade = grade

    @@all << self
  end

  # create database table "students"
  # .create_table -> []
  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL

    DB[:conn].execute(sql)

  end

  # dop table "students"
  # .drop_table -> []
  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students;
    SQL

    DB[:conn].execute(sql)
  end

  # saves instance as record
  # updates instance id
  # #save -> Instance
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students;")[0][0]
  end

  # creates instance
  # saves as record
  # .create -> Instance
  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
  
end
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  