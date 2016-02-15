using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UniversityManagemntSystem.Core.Gateway;
using UniversityManagemntSystem.Models;

namespace UniversityManagemntSystem.Core.BLL
{
    public class DayManager
    {
        DayGateway dayGateway=new DayGateway();
        public IEnumerable<Day> GetAllDays
        {
            get { return dayGateway.GetAllDays; }
        } 
    }
}