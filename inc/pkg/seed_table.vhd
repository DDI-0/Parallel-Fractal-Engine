library ads;
use ads.ads_fixed_pkg.all;
use ads.ads_complex_pkg.all;

package seed_table is
    type seed_rom_type is array (natural range<>) of ads_complex;
    constant seed_rom: seed_rom_type := (
        ads_cmplx(to_ads_fixed(-0.1000), to_ads_fixed(-0.9000)),
        ads_cmplx(to_ads_fixed(-0.0062), to_ads_fixed(-0.7147)),
        ads_cmplx(to_ads_fixed(0.0849), to_ads_fixed(-0.5365)),
        ads_cmplx(to_ads_fixed(0.1727), to_ads_fixed(-0.3723)),
        ads_cmplx(to_ads_fixed(0.2557), to_ads_fixed(-0.2262)),
        ads_cmplx(to_ads_fixed(0.3318), to_ads_fixed(-0.1012)),
        ads_cmplx(to_ads_fixed(0.3993), to_ads_fixed(0.0003)),
        ads_cmplx(to_ads_fixed(0.4573), to_ads_fixed(0.0737)),
        ads_cmplx(to_ads_fixed(0.5043), to_ads_fixed(0.1190)),
        ads_cmplx(to_ads_fixed(0.5396), to_ads_fixed(0.1347)),
        ads_cmplx(to_ads_fixed(0.5626), to_ads_fixed(0.1206)),
        ads_cmplx(to_ads_fixed(0.5729), to_ads_fixed(0.0775)),
        ads_cmplx(to_ads_fixed(0.5702), to_ads_fixed(0.0073)),
        ads_cmplx(to_ads_fixed(0.5544), to_ads_fixed(-0.0923)),
        ads_cmplx(to_ads_fixed(0.5263), to_ads_fixed(-0.2149)),
        ads_cmplx(to_ads_fixed(0.4873), to_ads_fixed(-0.3578)),
        ads_cmplx(to_ads_fixed(0.4392), to_ads_fixed(-0.5178)),
        ads_cmplx(to_ads_fixed(0.3827), to_ads_fixed(-0.6915)),
        ads_cmplx(to_ads_fixed(0.3197), to_ads_fixed(-0.8751)),
        ads_cmplx(to_ads_fixed(0.2522), to_ads_fixed(-1.0645)),
        ads_cmplx(to_ads_fixed(0.1822), to_ads_fixed(-1.2506)),
        ads_cmplx(to_ads_fixed(0.1113), to_ads_fixed(-1.4273)),
        ads_cmplx(to_ads_fixed(0.0419), to_ads_fixed(-1.5902)),
        ads_cmplx(to_ads_fixed(-0.0244), to_ads_fixed(-1.7367)),
        ads_cmplx(to_ads_fixed(-0.0858), to_ads_fixed(-1.8568)),
        ads_cmplx(to_ads_fixed(-0.1407), to_ads_fixed(-1.9475)),
        ads_cmplx(to_ads_fixed(-0.1882), to_ads_fixed(-1.9068)),
        ads_cmplx(to_ads_fixed(-0.2258), to_ads_fixed(-1.8328)),
        ads_cmplx(to_ads_fixed(-0.2520), to_ads_fixed(-1.7249)),
        ads_cmplx(to_ads_fixed(-0.2657), to_ads_fixed(-1.5838)),
        ads_cmplx(to_ads_fixed(-0.2665), to_ads_fixed(-1.4108)),
        ads_cmplx(to_ads_fixed(-0.2542), to_ads_fixed(-1.2083)),
        ads_cmplx(to_ads_fixed(-0.2291), to_ads_fixed(-1.0800)),
        ads_cmplx(to_ads_fixed(-0.1920), to_ads_fixed(-0.9297)),
        ads_cmplx(to_ads_fixed(-0.1445), to_ads_fixed(-0.7616)),
        ads_cmplx(to_ads_fixed(-0.0878), to_ads_fixed(-0.5797)),
        ads_cmplx(to_ads_fixed(-0.0226), to_ads_fixed(-0.3889)),
        ads_cmplx(to_ads_fixed(0.0481), to_ads_fixed(-0.1924)),
        ads_cmplx(to_ads_fixed(0.1220), to_ads_fixed(0.0052)),
        ads_cmplx(to_ads_fixed(0.1966), to_ads_fixed(0.1938)),
        ads_cmplx(to_ads_fixed(0.2697), to_ads_fixed(0.3686)),
        ads_cmplx(to_ads_fixed(0.3390), to_ads_fixed(0.5249)),
        ads_cmplx(to_ads_fixed(0.4023), to_ads_fixed(0.6598)),
        ads_cmplx(to_ads_fixed(0.4582), to_ads_fixed(0.7702)),
        ads_cmplx(to_ads_fixed(0.5051), to_ads_fixed(0.8532)),
        ads_cmplx(to_ads_fixed(0.5417), to_ads_fixed(0.9067)),
        ads_cmplx(to_ads_fixed(0.5669), to_ads_fixed(0.9292)),
        ads_cmplx(to_ads_fixed(0.5803), to_ads_fixed(0.9201)),
        ads_cmplx(to_ads_fixed(0.5808), to_ads_fixed(0.8800)),
        ads_cmplx(to_ads_fixed(0.5684), to_ads_fixed(0.8110)),
        ads_cmplx(to_ads_fixed(0.5437), to_ads_fixed(0.7195)),
        ads_cmplx(to_ads_fixed(0.5078), to_ads_fixed(0.6008)),
        ads_cmplx(to_ads_fixed(0.4616), to_ads_fixed(0.4613)),
        ads_cmplx(to_ads_fixed(0.4065), to_ads_fixed(0.3045)),
        ads_cmplx(to_ads_fixed(0.3416), to_ads_fixed(0.1340)),
        ads_cmplx(to_ads_fixed(0.2720), to_ads_fixed(-0.0461)),
        ads_cmplx(to_ads_fixed(0.1990), to_ads_fixed(-0.2318)),
        ads_cmplx(to_ads_fixed(0.1245), to_ads_fixed(-0.4215)),
        ads_cmplx(to_ads_fixed(0.0505), to_ads_fixed(-0.6085)),
        ads_cmplx(to_ads_fixed(-0.0204), to_ads_fixed(-0.7860)),
        ads_cmplx(to_ads_fixed(-0.0865), to_ads_fixed(-0.9502)),
        ads_cmplx(to_ads_fixed(-0.1458), to_ads_fixed(-1.0962)),
        ads_cmplx(to_ads_fixed(-0.1968), to_ads_fixed(-1.2209))
    );
    constant seed_rom_total: natural := seed_rom'length;
    subtype seed_index_type is natural range 0 to seed_rom_total - 1;
    function get_next_seed_index (
        index: in seed_index_type
    ) return seed_index_type;
end package seed_table;

package body seed_table is
    function get_next_seed_index (
        index: in seed_index_type
    ) return seed_index_type is
    begin
        if index = index'high then
            return 0;
        end if;
        return index + 1;
    end function get_next_seed_index;
end package body seed_table;
