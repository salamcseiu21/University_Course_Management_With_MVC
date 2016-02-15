using System.Collections.Generic;
using UniversityManagemntSystem.Core.Gateway;
using UniversityManagemntSystem.Models;

namespace UniversityManagemntSystem.Core.BLL
{
    public class DepartmentManager
    {
        DepartmentGateway departmentGateway=new DepartmentGateway();
        public IEnumerable<Department> GetAll()
        {
            return departmentGateway.GetAll();
        }

        public string Save(Department aDepartment)
        {
            if (!(IsDepartmentCodeValid(aDepartment)))
            {
                return "Department code must be between 2 to 7 character length";
            }
            if (IsDepartmentCodeExits(aDepartment))
            {
                return "Department Code must be unique";
            }
            if (IsDepartmentNameExits(aDepartment))
            {
                return "Department Name must be Uinque";
            }
            if (departmentGateway.Insert(aDepartment) > 0)
            {
                return "Saved Sucessfully";
            }
            return "Failed to save";
        }

        private bool IsDepartmentNameExits(Department aDepartment)
        {
            Department dept = departmentGateway.GetDepartmentByName(aDepartment.Name);
            
            if (dept != null)
            {
                return true;
            }
            return false;
        }

        private bool IsDepartmentCodeExits(Department aDepartment)
        {
            Department dept = departmentGateway.GetDepartmentByCode(aDepartment.Code.ToUpper());
                
            if (dept!=null)
            {
                return true;
            }
            return false;

            
        }

        private bool IsDepartmentCodeValid(Department
            aDepartment)
        {
            if (aDepartment.Code.Length >= 2 || aDepartment.Code.Length <= 7)
            {
                return true;
            }
            return false;
        }
    }
}