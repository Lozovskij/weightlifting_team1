using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.ModelsForOutput
{
    public class AthleteResult
    {
        public int Id { get; set; }

        [Display(Name = "Full name")]
        public string FullName { get; set; }

        public string Nation { get; set; }

        public double Weight { get; set; }

        [Display(Name = "Total result")]
        public int TotalResult { get; set; }
    }
}
