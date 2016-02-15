using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace UniversityManagemntSystem.Models
{
         //[MetadataType(typeof(Department))]
     public class Department
    {
        public int Id { get; set; }
  
         [Required(ErrorMessage = "Department Code id required!")]
         [StringLength(7,MinimumLength = 2,ErrorMessage = "Code must be minimum 2 and maximum 7 character of length!")]
        public string Code { get; set; }
        [Required(ErrorMessage = "Department Name id required!")]

        public string Name { get; set; }
    }
}