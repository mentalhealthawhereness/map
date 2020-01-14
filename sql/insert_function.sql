DROP FUNCTION IF EXISTS insert_crowd_mapping_data(text,text,text,text,text,text,text,text,text,text);
--Assumes only one value being inserted

CREATE OR REPLACE FUNCTION insert_crowd_mapping_data (
    _geojson TEXT,
    _region TEXT,
    _fname TEXT,
    _alt TEXT,
    _muni TEXT,
    _brgy TEXT,	
    _type TEXT, 
    _source TEXT,
    _researcher TEXT,
    _approxnum TEXT)    
--Has to return something in order to be used in a "SELECT" statement
RETURNS integer
AS $$
DECLARE 
    _the_geom GEOMETRY;
	--The name of your table in cartoDB
	_the_table TEXT := 'mhloc';
BEGIN
    --Convert the GeoJSON to a geometry type for insertion. 
    _the_geom := ST_SetSRID(ST_GeomFromGeoJSON(_geojson),4326); 
	

	--Executes the insert given the supplied geometry, description, and username, while protecting against SQL injection.
    EXECUTE ' INSERT INTO '||quote_ident(_the_table)||' (the_geom, region, fname, alt, muni, brgy, type, source, researcher, approxnum)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
            ' USING _the_geom, _region, _fname, _alt, _muni, _brgy, _type, _source, _researcher, _approxnum;
            
    RETURN 1;
END;
$$
LANGUAGE plpgsql SECURITY DEFINER ;

--Grant access to the public user
GRANT EXECUTE ON FUNCTION insert_crowd_mapping_data( text, text, text, text, text, text, text, text, text, text) TO publicuser;
