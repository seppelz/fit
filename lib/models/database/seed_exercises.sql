-- Seed data for exercises
INSERT INTO exercises (
    id, video_id, name, preparation, execution, goal, tips,
    muscle_group, category, is_sitting, is_theraband, is_dynamic, is_one_sided
) VALUES
-- Shoulder Exercises
(1, '4a2qcPcn62A', 'Mobilisation Schultergürtel 1 - sitzend',
    'Setzen Sie sich aufrecht auf den vorderen Teil ihres Stuhls',
    'Strecken Sie abwechselnd den rechten und linken Arm bis in die Fingerspitzen, so hoch es geht',
    'Mobilisation des Schultergürtels',
    NULL,
    'Schulter', 'Mobilisation', TRUE, FALSE, TRUE, FALSE),

(2, '8QnjAqC-Px0', 'Mobilisation Schultergürtel 2 - sitzend',
    'Setzen Sie sich aufrecht auf den vorderen Teil ihres Stuhls. Die Arme hängen locker herab',
    'Führen Sie die rechte Schulter hoch und gleichzeitig die linke herunter. Heben Sie anschließend beide Schultern an und lassen sie wieder fallen',
    'Mobilisation des Schultergürtels',
    NULL,
    'Schulter', 'Mobilisation', TRUE, FALSE, TRUE, FALSE),

-- Back Exercises
(520, 'L75JtiVDJd0', 'Rücken Mobilisation Extension - sitzend',
    'Setzen Sie sich auf dem Stuhl mit dem Gesäß bis an die Rückenlehne. Legen Sie einen Fuß auf das andere Knie. Ziehen Sie das Kinn ein',
    'Verschränken Sie ihre Hände hinter dem Kopf und dehnen Sie langsam den Oberkörper über den Stuhl nach hinten',
    'Mobilisation der Brustwirbelsäule',
    'Achten Sie auf eine gleichmäßige Atmung. Vermeiden Sie eine Hohlkreuzstellung',
    'Rücken', 'Mobilisation', TRUE, FALSE, TRUE, FALSE),

-- Belly Exercises
(100, 'qdm-jslCxyM', 'Kräftigung der Bauchmuskulatur - sitzend',
    'Setzen Sie sich aufrecht auf den vorderen Teil Ihres Stuhls. Ziehen Sie die Schultern nach unten und spannen die Bauchmuskeln an',
    'Neigen Sie im aufrechten Sitz den fixierten Oberkörper von der Hüfte ausgehend nach hinten. Die Bewegung erfolgt nur durch Streckung in den Hüftgelenken. Spannung halten',
    'Kräftigung des geraden Bauchmuskels',
    'Intensivieren Sie die Spannung indem Sie die Arme nach oben nehmen und kleine Bewegungen durchführen',
    'Bauch', 'Kraft', TRUE, FALSE, FALSE, FALSE),

-- Chest Exercises
(201, 'sG3qHG3S9XU', 'Kräftigung der Brustmuskulatur - sitzend',
    'Setzen Sie sich aufrecht auf den vorderen Teil Ihres Stuhls. Fixieren Sie das Theraband mittig mit beiden Füßen und greifen mit den Händen die Enden',
    'Führen Sie ihre Hände zur Schulter. Langsam in die Startposition zurückkehren',
    'Kräftigung des Bizeps und Brustmuskels',
    'Durch die Grundspannung des Therabandes in der Ausgansposition können Sie die Schwierigkeit variieren. Atmen Sie ruhig weiter und halten Sie die Oberkörperspannung',
    'Brust', 'Kraft', TRUE, TRUE, TRUE, FALSE),

-- Neck Exercises
(400, 'ehzVgbSxV6s', 'Kräftigung der Nackenmuskulatur - sitzend',
    'Setzen Sie sich aufrecht auf den vorderen Teil Ihres Stuhls',
    'Bei gerader Wirbelsäulenhaltung den Oberkörper 40 - 50° nach vorn neigen. Kopfbewegung langsam und ohne Schwung ausführen',
    'Kräftigung des Nackens',
    'Kein Schwung, ruhig weiteratmen',
    'Nacken', 'Kraft', TRUE, FALSE, TRUE, FALSE),

-- Butt Exercises
(303, 'GfJ8uRSIqOY', 'Kräftigung der Gesäßmuskulatur - stehend',
    'Legen Sie die Mitte des Therabandes um das Fußgelenk und fixieren Sie mit dem anderen Fuß das Theraband',
    'Das Bein langsam nach hinten führen. Kurz in der Endposition halten und langsam zurückführen',
    'Kräftigung der Gesäßmuskulatur',
    'Beine gestreckt lassen, nicht nach vorne lehnen. Durch die Grundspannung des Therabandes in der Ausgansposition können Sie die Schwierigkeit variieren. Atmen Sie ruhig weiter und halten Sie die Oberkörperspannung',
    'Po', 'Kraft', FALSE, TRUE, TRUE, TRUE);
