using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UniversityManagemntSystem.Core.Gateway;
using UniversityManagemntSystem.Models;

namespace UniversityManagemntSystem.Core.BLL
{
    public class CourseAssignToTeacherManager
    {
        CourseAssignToTeacherGateway courseAssignToTeacherGateway=new CourseAssignToTeacherGateway();
        public string Save(CourseAssignToTeacher courseAssign)
        {

            CourseAssignToTeacher courseAssignTo = GetAll.ToList().Find(ca => ca.CourseId == courseAssign.CourseId && ca.Status);

            if (courseAssignTo==null)
            {
                if (courseAssignToTeacherGateway.Insert(courseAssign) > 0)
                {
                    return "Saved sucessfully";
                }
                return "Failed to save";  
            }
            //CourseAssignToTeacher assignTo =
            //    GetAll.ToList().Find(c => c.CourseId == courseAssign.CourseId && c.TeacherId == courseAssign.TeacherId);
            //if (assignTo != null)
            //{
            //    bool st = assignTo.Status;
            //    if (st)
            //    {
            //        return "Overlaping not allowed during course assign";
            //    }
            //    if (courseAssignToTeacherGateway.Update(courseAssign) > 0)
            //    {
            //        return "Saved sucessfully";
            //    }
            //    return "Failed to save";

            //}

            return "Overlaping not allowed!";
        }


        public IEnumerable<CourseAssignToTeacher> GetAll
        {
            get { return courseAssignToTeacherGateway.GetAll; }
        } 

    }
}