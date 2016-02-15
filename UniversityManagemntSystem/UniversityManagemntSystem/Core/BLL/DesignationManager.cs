using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UniversityManagemntSystem.Core.Gateway;
using UniversityManagemntSystem.Models;

namespace UniversityManagemntSystem.Core.BLL
{
    public class DesignationManager
    {
        DesignationGateway designationGateway=new DesignationGateway();
        public IEnumerable<Designation> GetAll
        {

            get { return designationGateway.GetAll; }
        } 
    }
}