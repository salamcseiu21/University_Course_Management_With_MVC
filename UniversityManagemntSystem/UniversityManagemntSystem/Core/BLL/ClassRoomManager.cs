using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using UniversityManagemntSystem.Core.Gateway;
using UniversityManagemntSystem.Models;

namespace UniversityManagemntSystem.Core.BLL
{
    public class ClassRoomManager
    {
        ClassRoomGateway classRoomGateway=new ClassRoomGateway();

        public String Save(ClassRoom room)
        {
            if (room.StartTime > room.Endtime)
            {
                return "Time is Unvaluable.. Try Agein..!";
            }
            bool isTimeScheduleValid = IsTimeScheduleValid(room.RoomId, room.DayId, room.StartTime, room.Endtime);

            if (isTimeScheduleValid != true)
            {

                if (classRoomGateway.Insert(room) > 0)
                {
                    return "Saved Sucessfully!";
                }
                return "Failed to save";

            }
            return "Overlapping not allowed";
        }

        private bool IsTimeScheduleValid(int roomId, int dayId, DateTime startTime, DateTime endTime)
        {
            List<ClassRoom> schedule = classRoomGateway.GetClassSchedulByStartAndEndingTime(roomId, dayId, startTime, endTime);
            foreach (var sd in schedule)
            {
                if ((sd.DayId == dayId && roomId == sd.RoomId) &&
                                 (startTime < sd.StartTime && endTime > sd.StartTime )
                                 || (startTime < sd.StartTime && endTime > sd.StartTime) ||
                                 (startTime == sd.StartTime) ||(sd.StartTime<startTime&& sd.Endtime>startTime)
                                 )
                {
                    return true;
                }

            }
            return false;

            //if (schedule.Count==0)
            //{
            //    return true;
            //}
            //return false;
        }

        public List<ClassSchedule> GetAll
        {
            get { return classRoomGateway.GetAll; }
        }

        public List<TempClassSchedule> GetAllClassSchedules
        {
            get { return classRoomGateway.GetAllClassSchedules; }
        }




        public string GetAllClassSchedulesByDeparmentId(int departmentId,int courseId)
        {
           IEnumerable<TempClassSchedule> classSchedules=classRoomGateway.GetAllClassSchedulesByDeparmentId(departmentId,courseId);

           string output = "";
           
           foreach (var acls in classSchedules)
           {

               if (acls.RoomName.StartsWith("R"))
               {
                   output += acls.RoomName + ", " + acls.DayName + ", " + acls.StartTime.ToShortTimeString() + " - " + acls.EndTime.ToShortTimeString() + ";<br />";   
               }

               else if(acls.RoomName.StartsWith("N"))
               {
                   output = acls.RoomName;

               }
                    
               
           }

           return output;
        }

        public String UnAllocateClassRoom()
        {
            if (classRoomGateway.UnAllocateClassRoom() > 0)
            {
                return "UnAllocated Sucessfully";
            }
            return "Failed to Unallocate";
        }
    }
}