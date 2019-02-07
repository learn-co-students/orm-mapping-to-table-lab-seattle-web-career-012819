class Student
  attr_reader :id, :grade, :name
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
    SQL
    DB[:conn].execute(sql, self.name, self.grade)

    result = DB[:conn].execute("SELECT * FROM students")
    @id = result.last[0]
  end

  def self.create(data = {})
    name = data[:name]
    grade = data[:grade]
    new_student = Student.new(name, grade)
    new_student.save
    return new_student
  end

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

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students;
    SQL
    DB[:conn].execute(sql)
  end

end
