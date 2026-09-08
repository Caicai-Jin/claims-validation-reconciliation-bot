using ClaimsValidation.Core;

namespace ClaimsValidation.Tests;

public class ClaimValidatorTests{

    [Fact]
    public void ValidClaim_ReturnsValid(){
        var claim = new Claim{
            ClaimId = "C1001",
            MemberId = "M001",
            ProviderId = "P100",
            ServiceType = "Dental",
            ServiceDate = new DateTime(2026, 6, 1),
            Amount = 100
        };

        var member = new Member{
            CoverageStart = new DateTime(2026, 1, 1),
            CoverageEnd = new DateTime(2026, 12, 31)
        };

        var validator = new ClaimValidator();

        var result = validator.Validate(
            claim,
            member,
            500
        );

        Assert.True(result.IsValid);
        Assert.Empty(result.Reasons);
        Assert.Equal("", result.ReasonText);
    }

    [Theory]
    [InlineData(-20, 500, "INVALID_AMOUNT")]
    [InlineData(0, 500, "INVALID_AMOUNT")]
    [InlineData(500.01, 500, "COVERAGE_LIMIT_EXCEEDED")]
    [InlineData(700, 500, "COVERAGE_LIMIT_EXCEEDED")]
    public void InvalidAmountCases_ReturnExpectedReason(
    decimal amount,
    decimal limit,
    string expectedReason){
        var claim = new Claim{
            ClaimId = "C1001",
            MemberId = "M001",
            ProviderId = "P100",
            ServiceType = "Dental",
            ServiceDate = new DateTime(2026, 6, 1),
            Amount = amount
        };

        var member = new Member{
            CoverageStart = new DateTime(2026, 1, 1),
            CoverageEnd = new DateTime(2026, 12, 31)
        };

        var validator = new ClaimValidator();

        var result = validator.Validate(claim, member, limit);

        Assert.False(result.IsValid);
        Assert.Contains(expectedReason, result.Reasons);
    }

    [Fact]
    public void ExpiredCoverage_ReturnsInvalid()
    {
        var claim = new Claim{
            ClaimId = "C1001",
            MemberId = "M001",
            ProviderId = "P100",
            ServiceType = "Dental",
            ServiceDate = new DateTime(2026, 9, 1),
            Amount = 100
        };

        var member = new Member{
            CoverageStart = new DateTime(2026, 1, 1),
            CoverageEnd = new DateTime(2026, 8, 31)
        };

        var validator = new ClaimValidator();

        var result = validator.Validate(claim, member, 500);

        Assert.False(result.IsValid);
        Assert.Contains("COVERAGE_INACTIVE", result.Reasons);
    }

    [Fact]
    public void NullClaim_ThrowsArgumentNullException(){
        var validator = new ClaimValidator();
        var member = new Member();

        var exception = Assert.Throws<ArgumentNullException>(
            () => validator.Validate(null!, member, 500)
        );

        Assert.Equal("claim", exception.ParamName);
    }

    [Fact]
    public void NullMember_ThrowsArgumentNullException(){
        var validator = new ClaimValidator();
        var claim = new Claim();

        var exception = Assert.Throws<ArgumentNullException>(
            () => validator.Validate(claim, null!, 500)
        );

        Assert.Equal("member", exception.ParamName);
    }

    [Theory]
    [InlineData("ClaimId", null, "MISSING_CLAIM_ID")]
    [InlineData("ClaimId", "", "MISSING_CLAIM_ID")]
    [InlineData("ClaimId", "   ", "MISSING_CLAIM_ID")]
    [InlineData("MemberId", null, "MISSING_MEMBER_ID")]
    [InlineData("MemberId", "", "MISSING_MEMBER_ID")]
    [InlineData("MemberId", "   ", "MISSING_MEMBER_ID")]
    [InlineData("ProviderId", null, "MISSING_PROVIDER_ID")]
    [InlineData("ProviderId", "", "MISSING_PROVIDER_ID")]
    [InlineData("ProviderId", "   ", "MISSING_PROVIDER_ID")]
    [InlineData("ServiceType", null, "MISSING_SERVICE_TYPE")]
    [InlineData("ServiceType", "", "MISSING_SERVICE_TYPE")]
    [InlineData("ServiceType", "   ", "MISSING_SERVICE_TYPE")]
    public void MissingRequiredField_ReturnsExpectedReason(string field, string? value, string expectedReason) {

        var claim = new Claim {
            ClaimId = "C1001",
            MemberId = "M001",
            ProviderId = "P100",
            ServiceType = "Dental",
            ServiceDate = new DateTime(2026, 6, 1),
            Amount = 100
        };

        var member = new Member {
            CoverageStart = new DateTime(2026, 1, 1),
            CoverageEnd = new DateTime(2026, 12, 31)
        };

        switch (field) {
            case "ClaimId":
                claim.ClaimId = value!;
                break;
            case "MemberId":
                claim.MemberId = value!;
                break;
            case "ProviderId":
                claim.ProviderId = value!;
                break;
            case "ServiceType":
                claim.ServiceType = value!;
                break;
            default:
                throw new ArgumentException("Unknown test field.", nameof(field));
        }

        var validator = new ClaimValidator();

        var result = validator.Validate(claim, member, 500);

        Assert.False(result.IsValid);
        Assert.Single(result.Reasons);
        Assert.Contains(expectedReason, result.Reasons);
        Assert.Equal(expectedReason, result.ReasonText);
    }

    [Theory]
    [InlineData(2025, 12, 31, 12, false)]
    [InlineData(2026, 1, 1, 0, true)]
    [InlineData(2026, 6, 15, 12, true)]
    [InlineData(2026, 12, 31, 0, true)]
    [InlineData(2026, 12, 31, 23, true)]
    [InlineData(2027, 1, 1, 0, false)]
    public void CoverageDate_ReturnsExpectedValidity(
    int year,
    int month,
    int day,
    int hour,
    bool expectedValid) {

        var claim = new Claim {
            ClaimId = "C1001",
            MemberId = "M001",
            ProviderId = "P100",
            ServiceType = "Dental",
            ServiceDate = new DateTime(year, month, day, hour, 0, 0),
            Amount = 100
        };

        var member = new Member {
            CoverageStart = new DateTime(2026, 1, 1),
            CoverageEnd = new DateTime(2026, 12, 31)
        };

        var validator = new ClaimValidator();

        var result = validator.Validate(claim, member, 500);

        Assert.Equal(expectedValid, result.IsValid);

        if (expectedValid) {
            Assert.Empty(result.Reasons);
        }
        else {
            Assert.Single(result.Reasons);
            Assert.Contains("COVERAGE_INACTIVE", result.Reasons);
        }
    }

    [Theory]
    [InlineData(0.01, 500)]
    [InlineData(499.99, 500)]
    [InlineData(500, 500)]
    public void AmountWithinLimit_ReturnsValid(
    decimal amount,
    decimal limit) {

        var claim = new Claim {
            ClaimId = "C1001",
            MemberId = "M001",
            ProviderId = "P100",
            ServiceType = "Dental",
            ServiceDate = new DateTime(2026, 6, 1),
            Amount = amount
        };

        var member = new Member {
            CoverageStart = new DateTime(2026, 1, 1),
            CoverageEnd = new DateTime(2026, 12, 31)
        };

        var validator = new ClaimValidator();

        var result = validator.Validate(claim, member, limit);

        Assert.True(result.IsValid);
        Assert.Empty(result.Reasons);
    }

    [Fact]
    public void MultipleFailures_ReturnsAllReasons() {
        var claim = new Claim {
            ClaimId = "C1001",
            MemberId = "",
            ProviderId = "P100",
            ServiceType = "Dental",
            ServiceDate = new DateTime(2027, 1, 1),
            Amount = 700
        };

        var member = new Member {
            CoverageStart = new DateTime(2026, 1, 1),
            CoverageEnd = new DateTime(2026, 12, 31)
        };

        var validator = new ClaimValidator();

        var result = validator.Validate(claim, member, 500);

        Assert.False(result.IsValid);
        Assert.Equal(3, result.Reasons.Count);

        Assert.Contains("MISSING_MEMBER_ID", result.Reasons);
        Assert.Contains("COVERAGE_INACTIVE", result.Reasons);
        Assert.Contains("COVERAGE_LIMIT_EXCEEDED", result.Reasons);

        Assert.Equal(
            "COVERAGE_INACTIVE, COVERAGE_LIMIT_EXCEEDED, MISSING_MEMBER_ID",
            result.ReasonText
        );
    }

}