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

        [Display(Name = "Athlete country")]
        public string Country { get; set; }

        [Display(Name = "Sex")]
        public string Sex { get; set; }

        [Display(Name = "Birth date")]
        public DateTime BirthDate { get; set; }

        [Display(Name = "Had record")]
        public bool HadRecord { get; set; }

    }
}
