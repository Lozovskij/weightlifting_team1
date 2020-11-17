using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.Panels
{
    public class AttemptPanel
    {
        public AttemptPanel()
        {
            DateLowerLimit = new DateTime(1971, 1, 1);
            DateUpperLimit = DateTime.Now;
            //get it from the service
            Competitions = new string[] { "Olimpic games 2019", "Winter olimpics 22", "Universe competition" };
            //get it from the service
            AthleteNames = new string[] { "DIMAS Pyrros", "ASANIDZE George", "BAGHERI Kouroush", " WU Jingbiao" };
        }
        public string Period;
        public DateTime DateLowerLimit { get; set; }
        public DateTime DateUpperLimit { get; set; }
        public string[] Competitions;
        public string Competition;
        public bool SnatchIsIncluded { get; set; } = true;
        public bool PressIsIncluded { get; set; } = true;
        public bool CleanAndJerkIsIncluded { get; set; } = false;
        public int WeightLowerLimit { get; set; }
        public int WeightUpperLimit { get; set; }
        public int ResultLowerLimit { get; set; }
        public int ResultUpperLimit { get; set; }
        public string[] AthleteNames;
        public string AthleteName;
        public int AthleteId { get; set; }
        public bool IsDisqualified { get; set; }
        public bool ShowOnlyRecords { get; set; }
    }
}
