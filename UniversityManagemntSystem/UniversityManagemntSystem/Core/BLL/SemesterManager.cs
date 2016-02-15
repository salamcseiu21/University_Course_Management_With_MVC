using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UniversityManagemntSystem.Core.Gateway;
using UniversityManagemntSystem.Models;

namespace UniversityManagemntSystem.Core.BLL
{
    public class SemesterManager
    {
        SemesterGateway semesterGateway=new SemesterGateway();
        public List<Semester> GetAll
        {
            get { return semesterGateway.GetAll; }
        }
    }
}