using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace UniversityManagemntSystem.Models
{
    public class StudentResult
    {
        public int Id { get; set; }
        [Required(ErrorMessage = "Please! Select select a student Registration No")]
        [DisplayName("Student Reg No.")]
        public int StudentId { get; set; }

        public string Name { get; set; }
        public string Email { get; set; }
        public string Department { get; set; }
       
        public int  CourseId  { get; set; }
       
        public string Grade { get; set; }
        public bool Status { get; set; }
    }
}