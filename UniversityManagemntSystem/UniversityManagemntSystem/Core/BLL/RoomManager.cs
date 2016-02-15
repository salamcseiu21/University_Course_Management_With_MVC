using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UniversityManagemntSystem.Core.Gateway;
using UniversityManagemntSystem.Models;

namespace UniversityManagemntSystem.Core.BLL
{
    public class RoomManager
    {
        RoomGateway roomGateway=new RoomGateway();
        public IEnumerable<Room> GetAllRooms
        {
            get { return roomGateway.GetAllRooms; }
        }
    }
}