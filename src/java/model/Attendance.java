package model;

public class Attendance {
    private int    attendanceId;
    private int    studentId;
    private int    subjectId;
    private int    teacherId;
    private String date;   // stored as String "YYYY-MM-DD"
    private String status; // "Present" or "Absent"

    public Attendance() {}

    public Attendance(int attendanceId, int studentId, int subjectId,
                      int teacherId, String date, String status) {
        this.attendanceId = attendanceId;
        this.studentId    = studentId;
        this.subjectId    = subjectId;
        this.teacherId    = teacherId;
        this.date         = date;
        this.status       = status;
    }

    public int    getAttendanceId()             { return attendanceId; }
    public void   setAttendanceId(int id)       { this.attendanceId = id; }
    public int    getStudentId()                { return studentId; }
    public void   setStudentId(int id)          { this.studentId = id; }
    public int    getSubjectId()                { return subjectId; }
    public void   setSubjectId(int id)          { this.subjectId = id; }
    public int    getTeacherId()                { return teacherId; }
    public void   setTeacherId(int id)          { this.teacherId = id; }
    public String getDate()                     { return date; }
    public void   setDate(String date)          { this.date = date; }
    public String getStatus()                   { return status; }
    public void   setStatus(String status)      { this.status = status; }
}
