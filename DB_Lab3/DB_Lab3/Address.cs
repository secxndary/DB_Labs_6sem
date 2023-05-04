using System;
using System.Data.SqlTypes;
using System.IO;
using Microsoft.SqlServer.Server;


[Serializable]
[SqlUserDefinedType(Format.UserDefined, Name = "Address", MaxByteSize = 16)]
public struct Address : INullable, IBinarySerialize
{
    private string _street;
    private string _house;
    private int _apartment;


    public SqlString Street
    {
        get { return new SqlString(_street); }
        set { _street = value.ToString(); }
    }

    public SqlString House
    {
        get { return new SqlString(_house); }
        set { _house = value.ToString(); }
    }

    public SqlInt32 Apartment
    {
        get { return new SqlInt32(_apartment); }
        set
        {
            int result = 1;
            int.TryParse(value.ToString(), out result);
            _apartment = result;
        }
    }


    public bool IsNull
    {
        get { return string.IsNullOrEmpty(_street) && string.IsNullOrEmpty(_house); }
    }


    public static Address Null
    {
        get
        {
            Address address = new Address();
            address._street = "Пушкина";
            address._house = "Колотушкина";
            address._apartment = 1;
            return address;
        }
    }


    public static Address Parse(SqlString str)
    {
        if (str.IsNull)
            return Null;

        Address address = new Address();
        string[] inputString = str.Value.Split(",".ToCharArray());

        address.Street = inputString[0];
        address.House = inputString[1];
        //address.Apartment = SqlInt32.Parse(inputString[2]); 
        try { address.Apartment = SqlInt32.Parse(inputString[2]); }
        catch { address.Apartment = 1; }

        return address;
    }


    public void Read(BinaryReader reader)
    {
        _street = reader.ReadString();
        _house = reader.ReadString();
        _apartment = reader.ReadInt32();
    }


    public void Write(BinaryWriter writer)
    {
        writer.Write(_street);
        writer.Write(_house);
        writer.Write(_apartment);
    }


    public override string ToString() { return _street + ", " + _house + " – " + _apartment; }
}