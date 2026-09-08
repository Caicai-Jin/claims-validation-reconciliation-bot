using System;
using System.Collections.Generic;
using System.Text;

using ClaimsValidation.Core;

namespace ClaimsValidation.Tests;

public class IdNormalizerTests {
    [Theory]
    [InlineData("m001", "M001")]
    [InlineData(" M001 ", "M001")]
    [InlineData(" m001 ", "M001")]
    [InlineData("M001", "M001")]
    [InlineData("\tm001\r\n", "M001")]
    [InlineData("", "")]
    [InlineData("   ", "")]
    [InlineData(null, "")]
    public void Normalize_ReturnsExpectedValue(string? input,string expected){

        var result = IdNormalizer.Normalize(input);

        Assert.Equal(expected, result);
    }
}