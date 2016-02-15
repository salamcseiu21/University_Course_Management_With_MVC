using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UniversityManagemntSystem.Models
{
    public class TempClassSchedule
    {
        public int  Id { get; set; }
        public int DepartmentId { get; set; }
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public string  RoomName  { get; set; }
        public string  DayName { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public bool Status { get; set; }
    
    }
}