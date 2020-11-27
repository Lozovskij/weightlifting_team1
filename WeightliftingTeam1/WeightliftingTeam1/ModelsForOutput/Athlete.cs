using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.ModelsForOutput
{
    public class Athlete
    {
        public string Name { get; set; }

        public string Country { get; set; }

        public string Sex { get; set; }

        public string DOB { get; set; }
    }
}
