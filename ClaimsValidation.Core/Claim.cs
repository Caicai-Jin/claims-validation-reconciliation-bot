using System;
using System.Collections.Generic;
using System.Text;

namespace ClaimsValidation.Core;

public class Claim
{
    public string ClaimId { get; set; } = "";
    public string MemberId { get; set; } = "";
    public string ProviderId { get; set; } = "";
    public DateTime ServiceDate { get; set; }
    public decimal Amount { get; set; }
    public string ServiceType { get; set; } = "";
}
