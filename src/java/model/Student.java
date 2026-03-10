package model;

public class Student {
    private int    studentId;
    private String rollNo;
    private String name;
    private String email;
    private String department;
    private int    semester;
    private int    classId;
    private String username;
    private String password;

    public Student() {}

    public Student(int studentId, String rollNo, String name, String email,
                   String department, int semester, int classId,
                   String username, String password) {
        this.studentId  = studentId;
        this.rollNo     = rollNo;
        this.name       = name;
        this.email      = email;
        this.department = department;
        this.semester   = semester;
        this.classId    = classId;
        this.username   = username;
        this.password   = password;
    }

    public int    getStudentId()              { return studentId; }
    public void   setStudentId(int id)        { this.studentId = id; }
    public String getRollNo()                 { return rollNo; }
    public void   setRollNo(String r)         { this.rollNo = r; }
    public String getName()                   { return name; }
    public void   setName(String n)           { this.name = n; }
    public String getEmail()                  { return email; }
    public void   setEmail(String e)          { this.email = e; }
    public String getDepartment()             { return department; }
    public void   setDepartment(String d)     { this.department = d; }
    public int    getSemester()               { return semester; }
    public void   setSemester(int s)          { this.semester = s; }
    public int    getClassId()                { return classId; }
    public void   setClassId(int c)           { this.classId = c; }
    public String getUsername()               { return username; }
    public void   setUsername(String u)       { this.username = u; }
    public String getPassword()               { return password; }
    public void   setPassword(String p)       { this.password = p; }
}
