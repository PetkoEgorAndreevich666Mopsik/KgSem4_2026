Texture2D gDiffuseMap1 : register(t0);
Texture2D gDiffuseMap2 : register(t1);
SamplerState gSampler : register(s0);

cbuffer cbPerObject : register(b0)
{
    float4x4 mWorld;
    float4x4 mWorldViewProj;
    float4 mUVTransform;
    float4 mBlendFactor;
};

struct VSInput
{
    float3 Pos : POSITION;
    float3 Normal : NORMAL;
    float2 Tex : TEXCOORD;
};

struct VSOutput
{
    float4 PosH : SV_POSITION;
    float3 WorldPos : POSITION0;
    float3 Normal : NORMAL0;
    float2 TexC : TEXCOORD0;
};

struct PSOutput
{
    float4 Albedo : SV_Target0;
    float4 Normal : SV_Target1;
    float Depth : SV_Target2;
};

VSOutput VS(VSInput vin)
{
    VSOutput vout;

    float4 worldPos = mul(float4(vin.Pos, 1.0f), mWorld);
    vout.PosH = mul(float4(vin.Pos, 1.0f), mWorldViewProj);
    vout.WorldPos = worldPos.xyz;
    vout.Normal = normalize(mul(vin.Normal, (float3x3)mWorld));
    vout.TexC = vin.Tex * mUVTransform.xy + mUVTransform.zw;

    return vout;
}

PSOutput PS(VSOutput pin)
{
    PSOutput pout;

    // Интерполяция двух текстур
    float4 texColor1 = gDiffuseMap1.Sample(gSampler, pin.TexC);
    float4 texColor2 = gDiffuseMap2.Sample(gSampler, pin.TexC);

    // Плавная интерполяция между двумя текстурами
    pout.Albedo = lerp(texColor1, texColor2, mBlendFactor.x);

    pout.Normal = float4(pin.Normal, 1.0f);
    pout.Depth = pin.PosH.z;

    return pout;
}