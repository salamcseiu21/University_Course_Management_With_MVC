using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace UniversityManagemntSystem.Models
{
    public class Teacher
    {
        public int Id { get; set; }
        [Required(ErrorMessage = "Name is required!")]
        public string Name { get; set; }
         [Required(ErrorMessage = "Address is required!")]
        public string Address { get; set; }
         [Required(ErrorMessage = "Email is required!")]
        [EmailAddress(ErrorMessage = "Invalid Email Address")]
        public string Email { get; set; }
         [Required(ErrorMessage = "Contact is required!")]
         [DisplayName("Contact No.")]
        public string Contact { get; set; }
        [DisplayName("Designation")]
        public int DesignationId { get; set; }
         [DisplayName("Department")]
        public int DepartmentId { get; set; }
         [Required(ErrorMessage = "Credit to be taken is required!")]
        [DisplayName("Credit To be Taken")]
        [RegularExpression("^0*[1-9][0-9]*(\\.[0-9]+)?",ErrorMessage = "Please! enter a positive number ")]
        public double CreditTobeTaken { get; set; }
       
         public double CreditTaken { get; set; }
    }
}