using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
namespace UniversityManagemntSystem.Models
{
    public class Course
    {
        public int Id { get; set; }
        [Required(ErrorMessage = "Course code is required")]
       [StringLength(100,MinimumLength = 5,ErrorMessage = "Code must be minimub 5 character of length")]
        public string Code { get; set; }
         [Required(ErrorMessage = "Course Name is required")]
        public string Name { get; set; }
         [Required(ErrorMessage = "Course credit is required")]
        [Range(0.5,5.00,ErrorMessage = "Credit must be betwwen 0.5 and 5.00")]
        public double Credit { get; set; }
          [Required(ErrorMessage = "Course Description is required")]
        public string Description { get; set; }
        [DisplayName("Department")]
        [Required(ErrorMessage = "Please! Select department")]
        public int DepartmentId { get; set; }
        [DisplayName("Semester")]
        [Required(ErrorMessage = "Please! Select semester")]
        public int SemesterId { get; set; }
    }
}