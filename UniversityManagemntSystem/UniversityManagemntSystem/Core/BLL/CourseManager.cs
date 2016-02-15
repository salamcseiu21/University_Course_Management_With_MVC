using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UniversityManagemntSystem.Core.Gateway;
using UniversityManagemntSystem.Models;

namespace UniversityManagemntSystem.Core.BLL
{
    public class CourseManager
    {
        CourseGateway courseGateway=new CourseGateway();
        public IEnumerable<Course> GetAll
        {
            get { return courseGateway.GetAll; }
        } 
        public string Save(Course aCourse)
        {
            if (!(IsCorseCodeValid(aCourse)))
            {
                return "Course must be at least 5 character of length";
            }
            if (IsCourseCodeExits(aCourse.Code))
            {
                return "Course code must be unique";
            }
            if (IsCourseNameExits(aCourse.Name))
            {
                return "Course Name must be unique";
            }
            if (courseGateway.Insert(aCourse) > 0)
            {
                return "Saved Sucessfully";
            }
                return "Failed to save";
        }

        private bool IsCourseNameExits(string name)
        {

            Course course = courseGateway.GetCourseByName(name);
            if (course != null)
            {
                return true;
            }

            return false;  
        }

        private bool IsCourseCodeExits(string code)
        {
            Course course = courseGateway.GetCourseByCode(code.ToUpper());
            
            if (course != null)
            {
                return true;
            }
            
            return false;
        }

        private bool IsCorseCodeValid(Course aCourse)
        {
            if (aCourse.Code.Length > 5)
            {
                return true;
            }
            return false;

        }

        public IEnumerable<CourseViewModel> GetCourseViewModels
        {
            get { return courseGateway.GetCourseViewModels; }
        }

        public IEnumerable<Course> GetCoursesTakenByaStudentById(int id)
        {
            return courseGateway.GetCoursesTakeByaStudentByStudentId(id);
        } 
         public string UnAssignCourses()
        {
             if (courseGateway.UnAssignCourse() > 0)
             {
                 return "Unassign courses Sucessfull!";
             }
             return "Failed to unassign";
        }

         public IEnumerable<Course> GetCourseByDepartmentId(int departmentId)
         {
             return courseGateway.GetCourseByDepartmentId(departmentId);
         }
    }
}