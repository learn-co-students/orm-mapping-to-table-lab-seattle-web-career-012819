class Student
  attr_accessor :name, :grade
  attr_reader :id
  
  @@all = []
  def initialize(name, grade, id = nil)
    # attributes.each {|key, value| self.send(("#{key}="), value)}
    @name = name 
    @grade = grade 
    @id = id

    @@all << self
  end

  # def initialize(attributes={})
  #   @title = attributes['name']
  #   @description = attributes['grade']
  #   @id = attributes['id']

  #   @@all << self
  # end

  def self.all 
  @@all 
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    grade TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  

   def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?);
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT * FROM students").last[0]
  end

  def self.create(name:, grade:)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

end #end of class
