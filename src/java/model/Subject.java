package model;

public class Subject {
    private int    subjectId;
    private String subjectName;
    private String department;
    private int    semester;
    private int    teacherId;

    public Subject() {}

    public Subject(int subjectId, String subjectName, String department,
                   int semester, int teacherId) {
        this.subjectId   = subjectId;
        this.subjectName = subjectName;
        this.department  = department;
        this.semester    = semester;
        this.teacherId   = teacherId;
    }

    public int    getSubjectId()              { return subjectId; }
    public void   setSubjectId(int id)        { this.subjectId = id; }
    public String getSubjectName()            { return subjectName; }
    public void   setSubjectName(String s)    { this.subjectName = s; }
    public String getDepartment()             { return department; }
    public void   setDepartment(String d)     { this.department = d; }
    public int    getSemester()               { return semester; }
    public void   setSemester(int s)          { this.semester = s; }
    public int    getTeacherId()              { return teacherId; }
    public void   setTeacherId(int id)        { this.teacherId = id; }
}
