using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.Data;

namespace WeightliftingTeam1.Panels
{
    public class AttemptPanel
    {
        public AttemptPanel()
        {
            DateLowerLimit = new DateTime(1920, 1, 1);
            DateUpperLimit = DateTime.Now;
        }
        public DateTime DateLowerLimit { get; set; }
        public DateTime DateUpperLimit { get; set; }
        public string Competition;
        public bool SnatchIsIncluded { get; set; } = true;
        public bool PressIsIncluded { get; set; } = true;
        public bool CleanAndJerkIsIncluded { get; set; } = false;
        public int WeightLowerLimit { get; set; }
        public int WeightUpperLimit { get; set; } = 500;
        public int ResultLowerLimit { get; set; }
        public int ResultUpperLimit { get; set; } = 500;
        public string AthleteName;
        public int AthleteId { get; set; }
        public bool IsDisqualified { get; set; }
        //public bool ShowOnlyRecords { get; set; }

        public void ChangePeriodEvent(ChangeEventArgs e)
        {
            string period = e.Value.ToString();
            if (period == "1920 - 1972")
            {
                DateLowerLimit = new DateTime(1920, 1, 1);
                DateUpperLimit = new DateTime(1972, 12, 31);
            } 
            else if (period == "1973 - 1992")
            {
                DateLowerLimit = new DateTime(1973, 1, 1);
                DateUpperLimit = new DateTime(1992, 12, 31);
            }
            else if(period == "1993 - 1997")
            {
                DateLowerLimit = new DateTime(1993, 1, 1);
                DateUpperLimit = new DateTime(1997, 12, 31);
            }
            else if(period == "(current)1998+")
            {
                DateLowerLimit = new DateTime(1998, 1, 1);
                DateUpperLimit = DateTime.Now;
            }
        }
    }
}
