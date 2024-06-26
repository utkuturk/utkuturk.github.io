---
layout: page
permalink: /talks/
title:
---

{% include image.html url="../images/camp.png" caption="my view from my camp in the hills of şirince, july 16,  photo by me" width="800px" align="middle" %}

---

## Conference Poster & Talks

{% for talk in site.data.cv.conferences %}
{{talk.author}} ({{talk.year}}, {{talk.month}}). _{{talk.title}}_. {% if talk.isposter %}Poster presented {% if talk.isvirtual %}(virtually) {% endif %}at {{talk.conf}}.{% endif %} {% if talk.istalk %}Talk given {% if talk.isvirtual %}(virtually) {% endif %}at {{talk.conf}}.{% endif %} {% if talk.place %}{{talk.place}}.{% endif %} {% if talk.abs %}[[abstract]({{talk.abs}})]{% endif %} {% if talk.ho %}[[handout]({{talk.ho}})]{% endif %} {% if talk.slide %}[[slides]({{talk.slide}})]{% endif %} {% if talk.poster %}[[poster]({{talk.poster}})]{% endif %}

{% endfor %}

## Invited & Internal Talks

**Türk, U**. (February, 2024). _Timing of Agreement in Verb Planning_. Talk given at UMass/UMD Psycholinguistic Mixer. University of Massachusetts: Amherst, MA, USA.


**Türk, U**. (January, 2024). _Controlling morphosyntactic competition through phonology_. Talk given at S-Lab. University of Maryland: College Park, MD, USA. [handout](files/handouts/turk_suspended_affixation_handout.pdf)

**Türk, U**. (December, 2022). _As If they were Turkish As Ifs_. Talk given at Meaning Meeting. University of Maryland: College Park, MD, USA.

**Türk, U**. (October, 2022). _Sources of Bias in Psycholinguistic Data_. Talk given at Language Science Lunch Talks. Language Science Center, University of Maryland: College Park, MD, USA.

**Türk, U**. (February, 2019). _Is Accusative Case Really the Case?_ Talk given at 1st Bogazici University Student Conference on Theoretical and Experimental Linguistics. Bogazici University: Istanbul, Turkey.
