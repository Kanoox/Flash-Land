--[[AD CONSTRUCTOR]]
function ad(_group, _id, _pic1, _pic2, _sender, _subject, _hidden)
	if _hidden == nil then _hidden = false end
	if _subject == nil then _subject = 'Publicité' end

	return {
		group = _group,
		id = _id,
		pic1 = _pic1,
		pic2 = _pic2,
		sender = _sender .. ' ',
		subject = _subject,
	}
end


ads = {
--  ad ('group', 'What you'll type in chat', 'CHAR_FLOYD', 'ImageName', 'Ad Title', 'Ad Subtitle'),
    ad('admin', 'store', 'CHAR_FLOYD', '247', '24/7 Shop'),
    ad('admin', 'admin', 'CHAR_FLOYD', 'ADMIN', 'Administration', ''),
    ad('admin', 'adminwarning', 'CHAR_FLOYD', 'warningadmin', 'ATTENTION !', ''),
    ad('admin', 'merry', 'CHAR_FLOYD', 'merry', 'MerryWeather', ''),

    ad('event', 'gevent', 'CHAR_FLOYD', 'event', 'Event', ''),
    ad('event', 'event', 'CHAR_FLOYD', 'wellevents', 'WellEvents', ''),
    ad('banker', 'bank', 'CHAR_FLOYD', 'fleecabank', 'Fleeca Bank'),
    ad('cardealer', 'dealership', 'CHAR_FLOYD', 'PDM', 'Premium Deluxe Motorsport'),
    ad('bikedealer', 'bikedealer', 'CHAR_FLOYD', 'BNB', 'Concess Moto'),
    ad('bennys', 'bennys', 'CHAR_FLOYD', 'BENNYS', "Benny's"),
    ad('ammunation', 'ammunation', 'CHAR_FLOYD', 'ammunation', 'Ammunation'),
    ad('taxi', 'taxi', 'CHAR_FLOYD', 'CAB', 'Taxi'),
    ad('uber', 'uber', 'CHAR_FLOYD', 'UBER', 'Uber'),
    ad('ubereats', 'ubereats', 'CHAR_FLOYD', 'UBEREATS', 'UberEats'),
    --ad('gouv', 'gouv', 'CHAR_FLOYD', 'GOUV', 'Gouvernement', 'Information'),
    --ad('police', 'police', 'CHAR_FLOYD', 'police', 'Police', ''),
    ad('realestateagent', 'stoneagency', 'CHAR_FLOYD', 'stoneagency', 'Agence Immobilière'),
    --ad('journaliste', 'weazel', 'CHAR_FLOYD', 'weazelnews', 'Weazel News'),
    ad('sixt', 'sixt', 'CHAR_FLOYD', 'sixt', 'Sixt'),
    ad('casino', 'casino', 'CHAR_FLOYD', 'char_casino', 'The Diamond Casino'),
    ad('mechanic', 'mechanic', 'CHAR_FLOYD', 'meca', 'LS Custom'),
    --ad('ambulance', 'ems', 'CHAR_FLOYD', 'ems', 'EMS'),
    ad('unicorn', 'unicorn', 'CHAR_FLOYD', 'unicorn', 'Unicorn'),
    ad('burgershot', 'burgershot', 'CHAR_FLOYD', 'burgershot', 'Burgershot'),

   -- ad(nil, 'youtube', 'CHAR_FLOYD', 'youtube', 'Youtube', '{user}'),
    ad(nil, 'twitter', 'CHAR_FLOYD', 'twitter', 'Twitter', '{user}'),
    --ad(nil, 'twitterano', 'CHAR_FLOYD', 'twitter', 'Twitter', 'Anonyme'),
}

function findAdById(id)
	local output
	for _, item in ipairs(ads) do
		if item.id == id then output = item end
	end
	return output
end