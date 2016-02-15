using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace UniversityManagemntSystem.Models
{
    public class ClassSchedule
    {
        public int CourseId { get; set; }
        public int  DepartmentId { get; set; }
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public string Schedule { get; set; }


    }
}